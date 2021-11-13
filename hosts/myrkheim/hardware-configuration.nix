{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sdhci_pci" ];
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

  # CPUs + Threads per Core
  nix.maxJobs = lib.mkDefault 16;
}
