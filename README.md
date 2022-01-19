# NixOS Configuration

## Installation

1. Acquire NixOS:

    ```sh
    wget -O nixos.iso https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
    cp nixos.iso /dev/sd[0..9]
    ```

1. Boot into the installer.

1. Switch to root user: `sudo -i`.

1. Connect to WiFi.

    ```sh
    ifconfig # to find interface
    wpa_supplicant -B -i interface -c <(wpa_passphrase 'SSID' 'password')
    ```

1. Partition and mount.

    ```sh
    lsblk # to find device. i.e. nvme0n1

    parted /dev/nvme0n1 -- mklabel gpt
    parted /dev/nvme0n1 -- mkpart primary 512MiB -8GiB
    parted -a optimal /dev/nvme0n1 -- mkpart primary linux-swap -8GiB 100%
    parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
    parted /dev/nvme0n1 -- set 3 esp on

    mkfs.ext4 -L nixos /dev/nvme0n1p1
    mkswap -L swap /dev/nvme0n1p2
    mkfs.fat -F 32 -n boot /dev/nvme0n1p3

    mount /dev/disk/by-label/nixos /mnt
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
    swapon /dev/nvme0n1p2
    ```

1. Install flake.

    ```sh
    nix-shell -p git
    git clone https://github.com/rgnns/nixos-config.git
    exit

    cd nixos-config
    nix-shell
    nixos-install --root /mnt --option pure-eval no --flake .#host
    ```

1. Reboot

1. `passwd gl`

## Usage

- Updating: `nixos-rebuild switch --flake .#host --option pure-eval no`

## Hosts

### Myrkheim

#### About

- Memory: 62.5GiB
- Processor: Intel Core i5-10210U CPU @ 1.60GHz * 8
- Graphics: Mesa Intel UHD Graphics (CML GT2)
- Disk Capacity: 1.0TB

#### Firmware

System76 Meerkat (meer5)

#### Displays

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

##### LG HDR 4K

- Vendor: GSM
- Model Name: LG HDR 4K
- Resolution: 3840x2160 (16:9)
- Refresh Rate: 60.00Hz
- Scale: 100%
- HiDPI: true
- Mode: Enable to render LoDPI displays at HiDPI resolution
- HorizSync: 134.0kHz

## Fonts

- DejaVu Sans Mono
- DejaVu Sans
- DejaVu Serif
- Fira Mono
- Fira Sans
- Liberation Mono
- Liberation Sans
- Liberation Serif
- Nimbus Mono
- Nimbus Roman
- Nimbus Sans
- Noto Color Emoji
- Noto Sans
- Noto Serif
- Open Sans
- Roboto Slab
- Ubuntu
- Ubuntu Mono
