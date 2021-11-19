{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
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
      libqalculate
      qgnomeplatform
      paper-icon-theme
      xclip
      xdotool
      xorg.xwininfo
      (makeDesktopItem {
        name = "scratch-calc";
        desktopName = "Calculator";
        icon = "calc";
        exec = "scratch \"${tmux}/bin/tmux new-session -s calc -n calc qalc\"";
        categories = "Development";
      })
    ];

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
        material-icons
        siji
      ];
    };

    home.configFile = with config.modules; {
      "xtheme/Xresources".source = "${configDir}/Xresources";
    };

    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = "gnome";
    qt5 = { style = "gtk2"; platformTheme = "gtk2"; };

    services.xserver.displayManager.lightdm.greeters.mini.user = config.user.name;
    services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
      text-color = "#ff79c6"
      password-background-color = "#1E2029"
      window-color = "#181a23"
      border-color = "#181a23"
    '';
    services.xserver.displayManager.sessionCommands = ''
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
      ${pkgs.xorg.xrdb}/bin/xrdb -merge "$XDG_CONFIG_HOME"/xtheme/Xresources
    '';

    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
        rm -rf .compose-cache .nv .pki .dbus .fehbg
        [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
