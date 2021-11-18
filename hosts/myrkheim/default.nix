{ config, lib, pkgs, ... }:

{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  modules.shell.exa.enable = true;
  modules.shell.zsh.enable = true;
  modules.tools.emacs = {
    enable = true;
    enableDoom = true;
  };
  modules.tools.git.enable = true;
  modules.tools.gpg.enable = true;
  modules.tools.pass.enable = true;
  modules.tools.ssh.enable = true;
  modules.tools.vim.enable = true;
  modules.desktop.i3.enable = true;
  modules.desktop.apps.firefox.enable = true;
  modules.desktop.apps.spotify.enable = true;

  user.packages = with pkgs; [
    aseprite
    tuxguitar
  ];

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # TODO: move to bluetooth module
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.pulseaudio = {
    enable = true;
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
