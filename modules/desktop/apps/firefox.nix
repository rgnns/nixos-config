{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.firefox;
in {
  options.modules.desktop.apps.firefox = {
    enable = mkEnableOption "Firefox";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (firefox.override {
        extraNativeMessagingHosts = lib.optional config.modules.tools.pass.enable passff-host;
      })
    ];
  };
}
