{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.exa;
in {
  options.modules.shell.exa = {
    enable = mkEnableOption "Exa";
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.exa ];

    modules.shell.zsh.aliases = {
      ls = "${pkgs.exa}/bin/exa";
      ll = "${pkgs.exa}/bin/exa -l";
      la = "${pkgs.exa}/bin/exa -a";
      lt = "${pkgs.exa}/bin/exa --tree";
      lla = "${pkgs.exa}/bin/exa -la";
    };
  };
}
