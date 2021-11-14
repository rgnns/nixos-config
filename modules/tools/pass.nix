{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.tools.pass;
in {
  options.modules.tools.pass = {
    enable = mkEnableOption "Password-store";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (pass.withExtensions (exts: [
        exts.pass-otp
        exts.pass-genphrase
      ]))
    ];
  };
}
