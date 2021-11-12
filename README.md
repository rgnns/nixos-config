# NixOS Configuration

## Myrkheim

### About

- Memory: 62.5GiB
- Processor: Intel Core i5-10210U CPU @ 1.60GHz * 8
- Graphics: Mesa Intel UHD Graphics (CML GT2)
- Disk Capacity: 1.0TB

### Firmware

System76 Meerkat (meer5)

### Displays

To get information:

```sh
apt-get install read-edid # for parse-edid
for aCard in /sys/class/drm/card*
  if grep '^connected' ${aCard}/status >/dev/null 2>&1; then
    cardname="${aCard##*/}"
    if [ -e ${aCard}/edid ]; then
      cat ${aCard}/edid | parse-edid
    fi
  fi
done
```

- Vendor: GSM
- Model Name: LG HDR 4K
- Resolution: 3840x2160 (16:9)
- Refresh Rate: 60.00Hz
- Scale: 100%
- HiDPI: true
- Mode: Enable to render LoDPI displays at HiDPI resolution
- HorizSync: 134.0kHz

#### Sections

```
Section "Monitor"
Identifier "LG HDR 4K"
DisplaySize 600 340
Gamme 2.20
Option "DPMS" "true"
HorizSync 30-135
VertRefresh 56-61
Modeline 	"Mode 6" 148.50 1920 2008 2052 2200 1080 1084 1089 1125 +hsync +vsync
Modeline 	"Mode 0" 533.25 3840 3888 3920 4000 2160 2214 2219 2222 +hsync -vsync
Modeline 	"Mode 1" 266.64 3840 3848 3992 4000 2160 2214 2219 2222 +hsync -vsync
Modeline 	"Mode 2" 148.500 1920 2008 2052 2200 1080 1084 1089 1125 +hsync +vsync
Modeline 	"Mode 3" 74.250 1280 1390 1420 1650 720 725 730 750 +hsync +vsync
Modeline 	"Mode 4" 27.027 720 736 798 858 480 489 495 525 -hsync -vsync
Modeline 	"Mode 5" 25.200 640 656 752 800 480 490 492 525 -hsync -vsync
Modeline 	"Mode 7" 241.50 2560 2608 2640 2720 1440 1443 1448 1481 +hsync -vsync
Option "PreferredMode" "Mode 6"
EndSection

Section "Screen"
Identifier "Default Screen"
Device "Generic Video Card"
Monitor "LG HDR 4K"
DefaultDepth 24
SubSection "Display"
Modes "3840x2160"
EndSubSection
EndSection
```
