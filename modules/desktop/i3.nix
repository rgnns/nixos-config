{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.i3;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.i3 = {
    enable = mkEnableOption "i3wm";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
      rofi
      rofi-pass
      termite # add to module
      (polybar.override {
        i3Support = true;
        nlSupport = true;
        pulseSupport = true;
      })
    ];
  
    services = {
      picom.enable = false;
      redshift.enable = true;
      xserver = {
        enable = true;
        desktopManager.xterm.enable = false;
        displayManager = {
          defaultSession = "none+i3";
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };
        windowManager.i3.enable = true;
        windowManager.i3.extraPackages = with pkgs; [ dmenu i3lock lxappearance ];
      };
    };
  
    systemd.user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

    env.TERMINAL = "termite";
  
    home.configFile = {
      "i3" = { source = "${configDir}/i3"; recursive = true; };
      "rofi" = { source = "${configDir}/rofi"; recursive = true; };
      "rofi-pass" = { source = "${configDir}/rofi-pass"; recursive = true; };
      "polybar" = { source = "${configDir}/polybar"; recursive = true; };
    };
  };
}
