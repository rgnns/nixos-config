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

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ pkgs.alacritty ];

      home.configFile."alacritty" = {
        source = "${configDir}/alacritty";
        recursive = true;
      };
    }

    (mkIf cfg.makeDefault { env.TERMINAL = "alacritty"; })
  ]);
}
