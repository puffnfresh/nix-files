{ config, lib, pkgs, modulesPath, ... }:

let
  rockpro64-blobs =
    pkgs.fetchFromGitHub {
      owner = "batocera-linux";
      repo = "rockpro64-blobs";
      rev = "a884124623d45b81bb92b66ac636d358c5f52b42";
      sha256 = "sha256-+l0CQp055W1AS/EfCRdS6es6sRr1oH1pZbsUGgCDwl0=";
    };

  useMainline = false;

  mrfixitKernel =
    pkgs.linuxManualConfig {
      inherit (pkgs) stdenv lib;
      version = "4.4.301";
      kernelPatches = [
        {
          name = "workaround-selected-processor-armv8";
          patch = ./0001-mobile-nixos-Workaround-selected-processor-does-not-.patch;
        }
        {
          name = "rtl818x-includes";
          patch = ./0001-rtl818x-fix-includes-for-rtl8180-and-rtl8187.patch;
        }
      ];
      src = pkgs.fetchFromGitHub {
        owner = "mrfixit2001";
        repo = "rockchip-kernel";
        rev = "32a6141efc6b9ecb0e5a5db8e2403f776bc14992";
        sha256 = "sha256-wMMNEY7NZsERJXeYKU6YG2/6r3YlP2K9E7fWzr8zZLc=";
      };
      configfile = ./batocera.linux.aarch64.conf;
      config = import ./batocera.linux.aarch64.nix // {
        # systemd wants these but seems to work fine without them
        "CONFIG_DMIID" = "y";
        "CONFIG_AUTOFS4_FS" = "y";
      };
    };

  mainlineKernel =
     pkgs.buildLinux {
      version = "5.18.0-rc3";
      src = pkgs.fetchFromGitHub {
        owner = "R-ARM";
        repo = "kernel";
        rev = "7163094e74fae1b001a1975d1c95bb32b44c8ee3";
        sha256 = "sha256-L32m1hm4xF7FJe0bQjn0vpfhWtAlp/vmU0+h2dO892M=";
      };
      defconfig = "ragnarok_defconfig";
      structuredExtraConfig = {
        MODULES = lib.kernel.yes;
        ZPOOL = lib.kernel.yes;
      };
      kernelPatches = [];
    };

  dtbName =
    if useMainline
    then "rockchip/rk3399-rg552.dtb"
    else "rockchip/rk3399-rg552-linux.dtb";
in
{
  imports = [
    (modulesPath + "/profiles/base.nix")
    (modulesPath + "/installer/sd-card/sd-image.nix")
  ];

  boot.kernelParams = [
    "console=tty3"
    "console=ttyS2,1500000n8"
    "fbcon=rotate:3"
    "video=HDMI-A-1:1280x720@60"
  ];

  boot.initrd.availableKernelModules = lib.mkForce [ ];

  boot.kernelPackages = pkgs.linuxPackagesFor (if useMainline then mainlineKernel else mrfixitKernel);

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;

  services.openssh.enable = true;
  users.users.brian = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://github.com/puffnfresh.keys";
        sha256 = "0gv8wpjxvb18fmvjvlg5ba9phqdhrmyl86qkkv8n7s7kq4dy12di";
      }))
    ];
  };

  sdImage = {
    firmwarePartitionOffset = 16;
    firmwareSize = 128;
    compressImage = false;
    populateFirmwareCommands = ''
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./firmware -n ${dtbName}
    '';
    populateRootCommands = ''
    '';
    postBuildCommands = ''
      sfdisk -A $img 1

      dd if=${rockpro64-blobs}/idbloader.img of=$img bs=32k seek=1 conv=notrunc
      dd if=${rockpro64-blobs}/uboot.img     of=$img bs=64k seek=128 conv=notrunc
      dd if=${rockpro64-blobs}/trust.img     of=$img bs=64k seek=192 conv=notrunc
    '';
  };
}
