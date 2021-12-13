{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv = {
    enable = mkEnableOption "Direnv";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.direnv.enable = true;
    };

    home.configFile."direnv/lib/use_flake.sh".text = ''
      use_flake() {
        watch_file flake.nix
        watch_file flake.lock
        eval "$(nix print-dev-env)"
      }
    '';
  };
}
