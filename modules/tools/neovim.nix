{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.tools.neovim;
    configDir = config.dotfiles.configDir;
in {
  options.modules.tools.neovim = {
    enable = mkEnableOption "NeoVim";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      bat
      delta
      fzf
      neovim
      ripgrep
    ];

    modules.shell.zsh.aliases = {
      vi = "${pkgs.neovim}/bin/nvim";
    };

    home.configFile."bat/config".text = ''
      --theme="gruvbox-light"
    '';

    home.configFile."nvim" = {
      source = "${configDir}/neovim";
      recursive = true;
      onChange = ''
        nvim +PlugInstall +qall
      '';
    };
  };
}
