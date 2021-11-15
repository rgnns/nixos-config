{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.tools.emacs;
in {
  options.modules.tools.emacs = {
    enable = mkEnableOption "Emacs";
    enableDoom = mkEnableOption "Doom-Emacs";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs.overlay ];

    user.packages = with pkgs; [
      ((emacsPackagesNgGen emacsPgtkGcc).emacsWithPackages (epkgs: [
        epkgs.vterm
      ]))
    ] ++ lib.optionals cfg.enableDoom [
        binutils
        cmake
        coreutils
        editorconfig-core-c
        elvish
        fd
        gcc
        git
        graphviz
        gnutls
        imagemagick
        jq
        mdl
        nixfmt
        shellcheck
        sqlite
        (ripgrep.override { withPCRE2 = true; })
      ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  };
}
