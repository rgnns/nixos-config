{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.dev.js;
in {
  options.modules.dev.js = {
    enable = mkEnableOption "JavaScript";
    enableLSP = mkEnableOption "JS LSP";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        nodejs
        nodePackages.prettier
        nodePackages.stylelint
      ];
    }

    (mkIf cfg.enableLSP {
      user.packages = with pkgs; [ nodePackages.typescript-language-server ];
    })
  ]);
}
