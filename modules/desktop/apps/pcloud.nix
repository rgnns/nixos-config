{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.desktop.apps.pcloud;
in {
  options.modules.desktop.apps.pcloud = {
    enable = mkEnableOption "pCloud";
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.pcloud ];
  };
}
