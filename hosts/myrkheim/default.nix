{ config, lib, pkgs, ... }:

{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  modules.dev = {
    js = {
      enable = true;
      enableLSP = true;
    };
    python.enable = true;
  };
  modules.shell = {
    elvish.enable = true;
    exa.enable = true;
    git.enable = true;
    ssh.enable = true;
    zsh.enable = true;
  };
  modules.terminal = {
    alacritty.enable = true;
    kitty = {
      enable = true;
      makeDefault = true;
    };
    xst.enable = true;
  };
  modules.tools = {
    emacs = {
      enable = true;
      enableDoom = true;
    };
    gpg.enable = true;
    neovim.enable = true;
    pass.enable = true;
    vim.enable = false;
  };
  modules.desktop.i3.enable = true;
  modules.desktop.apps = {
    firefox.enable = true;
    pcloud.enable = true;
    spotify.enable = true;
    tuxguitar.enable = true;
  };

  user.packages = with pkgs; [
    aseprite
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
