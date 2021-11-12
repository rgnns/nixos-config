{ config, lib, pkgs, ... }:

{
  services.xserver = {
    monitorSection = ''
      Identifier "LG HDR 4K"
      VendorName "GSM"
      ModelName "LG HDR 4K"
      DisplaySize 600 340
      Gamma 2.20
      Option "DPMS" "true"
      HorizSync 30-135
      VertRefresh 56-61
      Modeline "Mode 6" 148.50 1920 2008 2052 2200 1080 1084 1089 1125 +hsync +vsync
      Modeline "Mode 0" 533.25 3840 3888 3920 4000 2160 2214 2219 2222 +hsync -vsync
      Modeline "Mode 1" 266.64 3840 3848 3992 4000 2160 2214 2219 2222 +hsync -vsync
      Modeline "Mode 2" 148.500 1920 2008 2052 2200 1080 1084 1089 1125 +hsync +vsync
      Modeline "Mode 3" 74.250 1280 1390 1420 1650 720 725 730 750 +hsync +vsync
      Modeline "Mode 4" 27.027 720 736 798 858 480 489 495 525 -hsync -vsync
      Modeline "Mode 5" 25.200 640 656 752 800 480 490 492 525 -hsync -vsync
      Modeline "Mode 7" 241.50 2560 2608 2640 2720 1440 1443 1448 1481 +hsync -vsync
      Option "PreferredMode" "Mode 6"
    '';

    screenSection = ''
      Identifier "Default Screen"
      Device "Generic Video Card"
      Monitor "LG HDR 4K"
      Option "SLI" "Off"
      Option "MultiGPU" "Off"
      Option "Stereo" "0"
    '';
  };
}
