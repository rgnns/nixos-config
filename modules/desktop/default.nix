{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
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
      libsForQt5.qtstyleplugin-kvantum
      qgnomeplatform
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
    };

    services.picom = {
      backend = "glx";
      vSync = true;
      opacityRules = [
        "100:class_g = 'aseprite'"
        "100:class_g = 'feh'"
        "100:class_g = 'Inkscape'"
        "100:class_g = 'krita'"
        "100:class_g = 'mpv'"
        "100:class_g = 'Peek'"
        "100:class_g = 'Rofi'"
        "100:class_g = 'VirtualBox Machine'"
        "99:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
      ];
      shadowExclude = [
        "class_g = 'firefox' && argb"
        "class_g = 'Rofi'"
        "_GTK_FRAME_EXTENTS@:c"
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
        "window_type = 'desktop'"
        "window_type = 'dock'"
        "window_type = 'dropdown_menu'"
        "window_type = 'menu'"
        "window_type = 'popup_menu'"
      ];
      settings = {
        blur-background-exclude = [
          "class_g = 'Rofi'"
          "_GTK_FRAME_EXTENTS@:c"
          "window_type = 'desktop'"
          "window_type = 'dock'"
        ];
        dbe = false;
      };
    };

    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = "gnome";
    env.QT_STYLE_OVERRIDE = "kvantum";

    services.xserver.displayManager.lightdm.greeters.mini.user = config.user.name;
    services.xserver.displayManager.sessionCommands = ''
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    '';

    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
        rm -rf .compose-cache .nv .pki .dbus .fehbg
        [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
