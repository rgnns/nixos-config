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
    user.packages = [ pkgs.picom ];

    home.configFile."picom/picom.conf".source = "${configDir}/picom/picom.conf";
    
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
