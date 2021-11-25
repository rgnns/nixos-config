{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.tools.neovim;
    configDir = config.dotfiles.configDir;

    vim-maximizer = pkgs.vimUtils.buildVimPlugin {
      name = "vim-maximizer";
      src = pkgs.fetchFromGitHub {
        owner = "szw";
        repo = "vim-maximizer";
        rev = "2e54952fe91e140a2e69f35f22131219fcd9c5f1";
        sha256 = "+VPcMn4NuxLRpY1nXz7APaXlRQVZD3Y7SprB/hvNKww=";
      };
    };
in {
  options.modules.tools.neovim = {
    enable = mkEnableOption "NeoVim";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      configure = {
        customRC = builtins.readFile "${configDir}/neovim/init.vim";
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            ctrlp-vim
            dart-vim-plugin
            editorconfig-vim
            fzf-vim
            gruvbox-nvim
            neoformat
            neoterm
            nerdtree
            nginx-vim
            rainbow_parentheses-vim
            vim-abolish
            vim-airline
            vim-airline-themes
            vim-commentary
            vim-maximizer
            vim-repeat
            vim-surround
            vim-tmux-navigator

            rust-vim
            swift-vim
            vim-bazel
            vim-elixir
            vim-graphql
            vim-javascript typescript-vim vim-jsdoc vim-jsx-pretty
            vim-markdown
            vim-nix
            vim-ruby
            vim-toml
            vimtex
          ];
        };
      };
    };
  };
}
