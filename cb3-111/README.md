# NixOS on the Acer CB3-111 Chromebook

It's now possible to boot Linux on Baytrail Chromebooks!

https://johnlewis.ie/custom-chromebook-firmware/rom-download/

I had a CB3-111 which I didn't use often and I wanted to use it for a
media centre system. Of course I was going to use NixOS to do
that. Turns out it wasn't as easy as I thought it would be.

The first problem was that the NixOS installation media would boot but
not pick up the internal MMC disk. After a lot of research, I found
that I needed the following kernel compile config set:

```
CONFIG_GPIOLIB=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_X86_INTEL_LPSS=y
```

NixOS has a script which answers y/m/n for each option when prompted
by the Linux kernel's "make config" step:

https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/kernel/generate-config.pl

Sadly it can't set arbitrary config it's not prompted for and for some
reason pinctrl options were removed from being shown at all:

https://github.com/torvalds/linux/commit/45f034ef205e5439a50d6f7e5f89add93131c0cc

So I wrote a tiny patch to add it back in, see
pinctrl-menu-option.patch for the line changed. There must be a better
way of setting the CONFIG_PINCTRL_BAYTRAIL config.

With a Nix expression which applies that patch and sets up the config,
I created a bootable ISO:

```
nix-build nixpkgs/nixos \
       -A config.system.build.isoImage \
       -I nixos-config=installer-baytrail-emmc.nix
```

Next I booted the live USB and saw /dev/mmcblk0!

I took a backup of the whole drive at this point:

```
dd if=/dev/mmcblk0 | gzip -1 | ssh backup-host "cat > cb3-111.mmcblk0.gz"
```

I used fdisk to delete all the partitions and then created them how I
liked:

```
Device            Start      End  Sectors  Size Type
/dev/mmcblk0p1     2048  4196351  4194304    2G Linux swap
/dev/mmcblk0p2  4196352 30782548 26586197 12.7G Linux filesystem
/dev/mmcblk0p3 30782549 30785502     2954  1.5M BIOS boot
```

Mounted p2 to /mnt, turned the swapon for p1 and then did a
nixos-generate-config. I updated the config with the kernel expression
that I wrote previously. I then did a nixos-install and left the
Celeron to compile the kernel for a few hours.

After a reboot the internal MMC drive was not detected, again. I was
able to enter a shell by appending `boot.shell_on_fail` to the Grub
kernel params. I compared the dmesg against what I saw when booting
from my working USB and saw that SDHCI wasn't being shown. I then
guessed it was a module not being loaded.

I did an lsmod and saw sdhci_acpi which would remove the mmcblk0
device if I did an rmmod on it. I rebuilt the configuration with
"sdhci_acpi" added to `boot.initrd.availableKernelModules` but the
drive was still not found. I compared lsmod and saw that sdhci_acpi
had mmc_block loaded on the USB but not on my installed kernel. Adding
"mmc_block" to the modules made it work perfectly!

The final step was to hook the computer up to my TV's HDMI and setting:

```nix
services.xserver.desktopManager.kodi.enable = true;
```

And now I have an awesome media player!

It's also possible for me to put it back to a normal Chromebook just
by loading my backup over the disk and then running John Lewis' ROM
script!
