{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.git;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.git = {
    enable = mkEnableOption "Git";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gitAndTools.diff-so-fancy
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/ignore".source = "${configDir}/git/ignore";
      "git/attributes".source = "${configDir}/git/attributes";
    };
  };
}
