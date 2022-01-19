{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.xserver.bspwm;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.xserver.bspwm = {
    enable = mkEnableOption "BSP Window Manager";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      feh
      libnotify
      libqalculate
      libsForQt5.qtstyleplugin-kvantum
      maim
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
      qgnomeplatform
      rofi
      rofi-power-menu
      xclip
      xdotool
      xorg.xdpyinfo
      xorg.xwininfo

      (makeDesktopItem {
        name = "scratch-calc";
        desktopName = "Calculator";
        icon = "calc";
        exec = "scratch \"${tmux}/bin/tmux new-session -s calc -n calc qalc\"";
        categories = "Development";
      })
    ] ++ lib.optional config.modules.tools.pass.enable rofi-pass;

    services.redshift.enable = true;

    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = "none+bspwm";
        sessionCommands = ''
          export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
          ${pkgs.xorg.xrdb}/bin/xrdb -merge "$XDG_CONFIG_HOME"/xtheme/Xresources
          ${pkgs.bspwm}/bin/bspc wm -r
          source $XDG_CONFIG_HOME/bspwm/bspwmrc
        '';
        lightdm = {
          enable = true;
          greeters.mini = {
            enable = true;
            user = config.user.name;
            extraConfig = ''
              text-color = "#282828";
              password-color = "#282828";
              password-background-color = "#f9f5d7";
              window-color = "#fefefe";
              border-color = "#fefefe";
              font-size = 12px;
            '';
          };
        }; 
      };
      windowManager.bspwm.enable = true;
    };

    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = "gnome";
    env.QT_STYLE_OVERRIDE = "kvantum";
    qt5 = { style = "gtk2"; platformTheme = "gtk2"; };

    modules.desktop.services.dunst.enable = true;
    modules.desktop.services.picom.enable = true;

    home.configFile = {
      "rofi" = { source = "${configDir}/rofi"; recursive = true; };
      "rofi-pass" = { source = "${configDir}/rofi-pass"; recursive = true; };
      "polybar" = { source = "${configDir}/polybar"; recursive = true; };
      "gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-icon-theme-name=Paper
        gtk-cursor-theme-name=Paper
        gtk-fallback-icon=gnome
        gtk-application-prefer-dark-theme=true
        gtk-xft-hinting=1
        gtk-xfg-hintstyle=hintful
        gtk-xft-rgba=none
      '';
      "gtk-2.0/gtkrc".text = ''
        gtk-font-name="Sans 10"
      '';
      "xtheme/Xresources" = {
        source = "${configDir}/Xresources";
        onChange = ''
          ${pkgs.xorg.xrdb}/bin/xrdb -merge "$XDG_CONFIG_HOME"/xtheme/Xresources
        '';
      };
      "sxhkd".source = "${configDir}/sxhkd";
      "bspwm/bspwmrc" = {
        source = pkgs.writeShellScript "bspwmrc" ''
          ( sleep 3 && bspc monitor ${config.env.MONITOR} -d 1 2 3 4 5 )

          bspc config remove_disabled_monitors true
          bspc config remove_unplugged_monitors true

          bspc rule -r '*'
          bspc rule -a Pinentry state=floating center=on
          bspc rule -a Emacs split_ratio=0.28 state=tiled
          bspc rule -a Firefox split_ratio=0.32
          bspc rule -a feh state=fullscreen
          bspc rule -a '*:scratch' state=floating sticky=on center=on border=off rectangle=1000x800+0+0

          for file in $XDG_CONFIG_HOME/bspwm/rc.d/*; do
            source "$file"
          done

          $XDG_CONFIG_HOME/polybar/launch.sh
        '';
        onChange = ''
          ${pkgs.bspwm}/bin/bspc wm -r
          source $XDG_CONFIG_HOME/bspwm/bspwmrc
        '';
      };
      "bspwm/rc.d/theme" = {
        source = "${configDir}/bspwm/rc.d/theme";
        onChange = ''
          ${pkgs.bspwm}/bin/bspc wm -r
          source $XDG_CONFIG_HOME/bspwm/bspwmrc
        '';
      };
    };

    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
        rm -rf .compose-cache .nv .pki .dbus .fehbg
        [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
