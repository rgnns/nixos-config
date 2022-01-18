{ config, options, lib, pkgs, ...}:

with lib;
let cfg = config.modules.desktop.xserver.gnome;
in {
  options.modules.desktop.xserver.gnome = {
    enable = mkEnableOption "Gnome Desktop Environment";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
    services.xserver = {
      enable = true;
      displayManager.gdm = {
          enable = true;
          wayland = true;
      };
      desktopManager.gnome.enable = true;
    };
    environment.systemPackages = with pkgs; [
      gnome3.adwaita-icon-theme
    ];
  }; 
}
