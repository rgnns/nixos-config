{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.dev.formatters;
in {
  options.modules.dev.formatters = {
    enable = mkEnableOption "All usual formatters";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      bazel-buildtools
      nixfmt
      rufo
      rustfmt
    ];
  };
}
