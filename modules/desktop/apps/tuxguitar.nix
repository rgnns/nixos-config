{ config, options, lib, pkgs, ... }:

with lib;
let cfg = config.modules.desktop.apps.tuxguitar;
in {
  options.modules.desktop.apps.tuxguitar = {
    enable = mkEnableOption "TuxGuitar";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      tuxguitar
      (makeDesktopItem {
        name = "tuxguitar";
        desktopName = "Tux Guitar";
        genericName = "Tux Guitar";
        icon = "guitar";
        exec = "${pkgs.tuxguitar}/bin/tuxguitar";
        categories = "Music";
      })
    ];
  };
}
