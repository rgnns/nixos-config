{ config, lib, pkgs, ... }:

{
  imports = [
    ../home.nix
    ../monitor-lg-hdr4k.nix
    ./hardware-configuration.nix
  ];

  modules.shell.zsh.enable = true;
  modules.tools.git.enable = true;
  modules.desktop.i3.enable = true;

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # TODO: move to bluetooth module
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };
  hardware.bluetooth.settings.General.Enable = "Source,Sink,Media,Socket";

  networking = {
    networkmanager.enable = true;
    interfaces.wlp0s20f3.useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };
}
