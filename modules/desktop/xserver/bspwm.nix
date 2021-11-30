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
    services.xserver.enable = true;
    services.xserver.displayManager.defaultSession = "none+bspwm";
    services.xserver.windowManager.bspwm.enable = true;
    home.configFile = {
      "sxhkd".source = "${configDir}/sxhkd";
      "bspwm" = {
        source = "${configDir}/bspwm";
        recursive = true;
        onChange = ''
          ${pkgs.bspwm}/bin/bspc wm -r
          source $XDG_CONFIG_HOME/bspwm/bspwmrc
        '';
      };
    };
  };
}
