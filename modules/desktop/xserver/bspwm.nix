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
    services.xserver = {
      enable = true;
      displayManager = {
        defaultSession = "none+bspwm";
        sessionCommands = ''
          ${pkgs.bspwm}/bin/bspc wm -r
          source $XDG_CONFIG_HOME/bspwm/bspwmrc
        '';
        lightdm.enable = true;
        lightdm.greeters.mini.enable = true;
      };
      windowManager.bspwm.enable = true;
    };
    home.configFile = {
      "sxhkd".source = "${configDir}/sxhkd";
      "bspwm/bspwmrc" = {
        source = pkgs.writeShellScript "bspwmrc" ''
          ( sleep 3 && bspc monitor DP-2 -d 1 2 3 4 5 )

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
  };
}
