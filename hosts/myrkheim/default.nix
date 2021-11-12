{ config, lib, pkgs, ... }:

{
  imports = [
    ../home.nix
    ../monitor-lg-hdr4k.nix
    ./hardware-configuration.nix
  ];

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking = {
    networkmanager.enable = true;
    interface.wlp0s20f3.useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };
}
