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
    user.packages = with pkgs; [ emacs ]
      ++ lib.optionals cfg.enableDoom [
        cmake
        fd
        imagemagick
        jq
        sqlite
        (ripgrep.override { withPCRE2 = true; })
      ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  };
}
