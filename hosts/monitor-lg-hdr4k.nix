{ config, lib, pkgs, ... }:

{
  services.xserver = {
    monitorSection = ''
      VendorName "GSM"
      ModelName "LG HDR 4K"
      Option "DPMS"
      HorizSync 30-135
      VertRefresh 56-61
    '';

    screenSection = ''
      Option "SLI" "Off"
      Option "MultiGPU" "Off"
      Option "Stereo" "0"
    '';
  };
}
