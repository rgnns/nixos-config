{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.tools.git;
    configDir = config.dotfiles.configDir;
in {
  options.modules.tools.vim = {
    enable = mkEnableOption "Vim setup";
  };

  config = mkIf cfg.enable {
    home.file.".vimrc".source = "${configDir}/vim/vimrc.vim";
    home.file.".vim/bundles.vim" = {
      source = "${configDir}/vim/bundles.vim";
      onChange = ''
        vim +PlugInstall +qall
      '';
    };
  };
}
