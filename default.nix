{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports = [ inputs.home-manager.nixosModule ]
            ++ (mapModulesRec' (toString ./modules) import);
  nix =
    let filteredInputs = filterAttrs (n: _: n != "self") inputs;
        nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
        registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in {
      package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
      nixPath = nixPathInputs ++ [
        "dotfiles=${config.dotfiles.dir}"
      ];
      binaryCaches = [ "https://nix-community.cachix.org" ];
      binaryCachePublicKeys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      registry = registryInputs // { dotfiles.flake = inputs.self; };
      autoOptimiseStore = true;
      gc = {
        automatic = true;
        options = "--delete-older-than 5d";
      };
    };

  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "21.11";

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_5_14;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    tmpOnTmpfs = mkDefault true;
    cleanTmpDir = lib.mkDefault (!config.boot.tmpOnTmpfs);
  };

  security.protectKernelImage = true;
  security.acme.acceptTerms = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # the bare minimum
  environment.systemPackages = with pkgs; [
    cached-nix-shell
    git
    gnumake
    networkmanager
    vim
    wget
  ];
}
