{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "sdhci_pci"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
 
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.video.hidpi.enable = lib.mkDefault true;

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCode = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      vaapiIntel
      vaapiVdpau
    ];
  };

  # CPUs + Threads per Core
  nix.maxJobs = lib.mkDefault 16;

  env.MONITOR = "DP-2";
}
