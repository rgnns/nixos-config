{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.zsh;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.zsh = with types; {
    enable = mkEnableOption "Zsh";

    aliases = mkOption {
      type = (attrsOf (either str path));
      default = {};
    };

    rcInit = mkOption {
      type = lines;
      default = "";
    };

    envInit = mkOption {
      type = lines;
      default = "";
    };

    rcFiles = mkOption {
      type = (listOf (either str path));
      default = [];
    };

    envFiles = mkOption {
      type = (listOf (either str path));
      default = [];
    };
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableGlobalCompInit = false;
      promptInit = "";
    };

    user.packages = with pkgs; [
      exa
      fasd
      fd
      fzf
      nix-zsh-completions
      ripgrep
      zsh
    ];

    env = {
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
      ZGEN_DIR = "$XDG_DATA_HOME/zsh";
      ZGEN_SOURCE = "$ZGEN_DIR/zgen.zsh";
    };

    home.configFile = {
      "zsh" = { source = "${configDir}/zsh"; recursive = true; };
      "zsh/extra.zshrc".text =
        let aliases = mapAttrsToList (n: v: "alias ${n}=\"${v}\"") cfg.aliases;
	in ''
	  # This file was auto-generated, do not edit.
	  ${concatStringsSep "\n" aliases}
	  ${concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
	  ${cfg.rcInit}
	'';
      "zsh/extra.zshenv".text = ''
        # This file was autogenerated, do not edit.
	${concatMapStrings (path: "source '${path}'\n") cfg.envFiles}
	${cfg.envInit}
      '';
    };

    system.userActivationScripts.cleanupZgen = "rm -fv $XDG_CACHE_HOME/zsh/*";
  };
}
