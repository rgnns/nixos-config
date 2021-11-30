{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.xserver.i3;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.xserver.i3 = {
    enable = mkEnableOption "i3wm";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.i3status-rust ];

    services.xserver.displayManager.defaultSession = "none+i3";
    services.xserver.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3lock
        lxappearance
      ];
    };

    home.configFile =
      let restartI3 = ''
        i3Socket=''${XDG_RUNTIME_DIR:-/run/user/$UID}/i3/ipc-socket.*
        if [ -S $i3Socket ]; then
          echo "Reloading i3"
          $DRY_RUN_CMD ${pkgs.i3-gaps}/bin/i3-msg -s $i3Socket restart 1>/dev/null
        fi
      ''; in {
        "i3" = {
          source = "${configDir}/i3";
          recursive = true;
          onChange = restartI3;
        };
        "i3status-rust" = {
          source = "${configDir}/i3status-rust";
          recursive = true;
          onChange = restartI3;
        };
    };
  };
}
