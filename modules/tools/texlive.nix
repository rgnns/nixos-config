{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.tools.texlive;
in {
  options.modules.tools.texlive = {
    enable = mkEnableOption "TexLive";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.texlive = {
        enable = true;
        extraPackages = tpkgs: {
          inherit (tpkgs) scheme-full;
          pkgFilter = pkg:
               pkg.tlType == "run"
            || pkg.tlType == "bin"
            || pkg.pname == "latex2e-help-texinfo";
        };
      };
    };
  };
}
