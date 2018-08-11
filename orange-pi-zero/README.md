# NixOS on Orange Pi Zero

## Limitations

1. Looks like the on board wifi doesn't work
2. Low memory (e.g. 256MB) means using a swap file which is not good for flash memory

## Hardware

1. Orange Pi Zero
2. SD card (at least 8GB work well, 4GB probably won't)
3. UART to USB adaptor
4. Ethernet cable connected to your network

## Steps

1. Download [sd-image-armv7l-linux.img](http://nixos-arm.dezgeg.me/installer)

2. [Build u-boot](https://nixos.wiki/wiki/NixOS_on_ARM#Building_u-boot_from_your_NixOS_PC) using orangepi_zero_defconfig to get `u-boot-sunxi-with-spl.bin`

3. Copy to SD card with `sudo bash -c "pv sd-image-armv7l-linux.img > /dev/mmcblk0"` and `sudo dd if=u-boot-sunxi-with-spl.bin of=/dev/mmcblk0 bs=1024 seek=8 conv=notrunc`

4. Boot Orange Pi Zero with SD card and attached to Ethernet

5. Attach via [UART](http://linux-sunxi.org/Xunlong_Orange_Pi_Zero#Locating_the_UART) with `sudo screen /dev/ttyUSB0 115200`

6. Enable SSH with `sudo systemctl start sshd`

7. Set a password for the root user with `passwd`

7. SSH into Orange Pi Zero with root user and chosen password

8. Create a 2G swap file with `dd if=/dev/zero of=/tmp/swapfile bs=1M count=2048` and enable with `chmod 0600 /tmp/swapfile && mkswap /tmp/swapfile && swapon /tmp/swapfile`

9. Modify and copy this configuration.nix over `/etc/nixos/configuration.nix`

10. Do a `nixos-rebuild switch`
