{ config, lib, pkgs, ... }:

{
  imports = [
    ../home.nix
    ../monitor-lg-hdr4k.nix
    ./hardware-configuration.nix
  ];

  modules.shell.zsh.enable = true;

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

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
