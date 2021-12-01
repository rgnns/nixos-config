{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.xserver;
    configDir = config.dotfiles.configDir;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message = "Can't have more than one desktop environments enabled at a time";
      }
      {
        assertion =
          let srv = config.services;
          in srv.xserver.enable ||
             srv.sway.enable ||
             !(anyAttrs
               (n: v: isAttrs v &&
                      anyAttrs (n: v: isAttrs v && v.enable))
               cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = with pkgs; [
      feh
      libnotify
      libqalculate
      libsForQt5.qtstyleplugin-kvantum
      maim
      paper-icon-theme
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

    fonts = {
      enableDefaultFonts = true;
      enableGhostscriptFonts = true;
      fontDir.enable = true;
      fonts = with pkgs; [
        fira-code
        fira-code-symbols
        font-awesome-ttf
        (iosevka-bin.override { variant = "ss15"; })
        jetbrains-mono
        material-design-icons
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
        siji
      ];
    };

    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    env.QT_QPA_PLATFORMTHEME = "gnome";
    env.QT_STYLE_OVERRIDE = "kvantum";
    qt5 = { style = "gtk2"; platformTheme = "gtk2"; };

    services = {
      redshift.enable = true;
      xserver = {
        displayManager = {
          sessionCommands = ''
            export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
            ${pkgs.xorg.xrdb}/bin/xrdb -merge "$XDG_CONFIG_HOME"/xtheme/Xresources
          '';
          lightdm = {
            enable = true;
            greeters.mini = {
              user = config.user.name;
              extraConfig = ''
                text-color = "#282828"
                password-color = "#282828"
                password-background-color = "#f9f5d7"
                window-color = "#fefefe"
                border-color = "#fefefe"
                font-size = 12px
              '';
            };
          };
        };
      };
    };

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
    };

    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
        rm -rf .compose-cache .nv .pki .dbus .fehbg
        [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
