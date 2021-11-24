{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.terminal.alacritty;
    configDir = config.dotfiles.configDir;
in {
  options.modules.terminal.alacritty = {
    enable = mkEnableOption "AlacriTTY";
    makeDefault = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alacritty
      (makeDesktopItem {
        name = "alacritty";
        desktopName = "AlacriTTY";
        icon = "utilities-terminal";
        exec = "${alacritty}/bin/alacritty";
        categories = "Development;System;Utility";
      })
    ];

    home.configFile."alacritty" = {
      source = "${configDir}/alacritty";
      recursive = true;
    };
  } // lib.optionalAttrs cfg.makeDefault {
    env.TERMINAL = "alacritty";
  };
}
