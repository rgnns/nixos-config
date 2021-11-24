{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.terminal.kitty;
    configDir = config.dotfiles.configDir;
in {
  options.modules.terminal.kitty = {
    enable = mkEnableOption "KiTTY";
    makeDefault = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kitty
      (makeDesktopItem {
        name = "kitty";
        desktopName = "KiTTY";
        icon = "utilities-terminal";
        exec = "${kitty}/bin/kitty";
        categories = "Development;System;Utility";
      })
    ];

    home.configFile."kitty" = {
      source = "${configDir}/kitty";
      recursive = true;
    };
  } // lib.optionalAttrs cfg.makeDefault {
    env.TERMINAL = "kitty";
  };
}
