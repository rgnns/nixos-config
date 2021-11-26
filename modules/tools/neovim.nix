{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.tools.neovim;
    configDir = config.dotfiles.configDir;
in {
  options.modules.tools.neovim = {
    enable = mkEnableOption "NeoVim";
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.neovim ];

    modules.shell.zsh.aliases = {
      vim = "${pkgs.neovim}/bin/nvim";
    };

    home.configFile."nvim" = {
      source = "${configDir}/neovim";
      recursive = true;
      onChange = ''
        nvim +PlugInstall +qall
      '';
    };
  };
}
