{ config, lib, pkgs, ... }:

{
  imports = [
    ../home.nix
    ../monitor-lg-hdr4k.nix
    ./hardware-configuration.nix
  ];

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # TODO: move to zsh module
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableGlobalCompInit = false;
    promptInit = "";
  };

  networking = {
    networkmanager.enable = true;
    interface.wlp0s20f3.useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  user.packages = with pgks; [
    exa
    nix-zsh-completions
    zsh
  ];

  env = {
    ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
    ZGEN_DIR = "$XDG_DATA_HOME/zsh";
    ZGEN_SOURCE = "$ZGEN_DIR/zgen.zsh";
  };
}
