{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.services.picom;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.services.picom = {
    enable = mkEnableOption "Picom";
  };

  config = mkIf cfg.enable {
    home.configFile."picom/picom.conf".source = "${configDir}/picom/picom.conf";

    services.picom = {
      backend = "glx";
      vSync = false;
      fade = true;
      fadeDelta = 1;
      shadow = true;
      shadowOffsets = [ (-10) (-10) ];
      shadowOpacity = 0.22;
      opacityRules = [
        "100:class_g = 'VirtualBox Machine'"
        "100:class_g = 'Gimp'"
        "100:class_g = 'aseprite'"
        "100:class_g = 'krita'"
        "100:class_g = 'feh'"
        "100:class_g = 'mpv'"
        "100:class_g = 'Rofi'"
        "100:class_g = 'Peek'"
        "99:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
      ];
      shadowExclude = [
        "! name~='(rofi|scratch|Dunst)$'"
      ];
      settings = {
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "class_g = 'Rofi'"
          "_GTK_FRAME_EXTENTS@:c"
        ];
        unredir-if-possible = true;
        glx-no-stencil = true;
        xrender-sync-fence = true;
        shadow-radius = 12;
        blur-kern = "7x7box";
        blur-strength = 320;
      };
    };
    
    systemd.user.services.picom = {
      description = "Picom X11 compositor";
      after = [ "graphical-session-pre.target" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.picom}/bin/picom";
        Restart = "always";
        RestartSec = 3;
        Environment = [ "allow_rgb10_configs=false" ];
      };
    };
  };
}
