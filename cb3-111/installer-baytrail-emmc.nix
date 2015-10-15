{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];

  boot.kernelPackages = pkgs.linuxPackages_latest // {
    kernel = pkgs.linux_latest.override (drv: {
      kernelPatches = [
        { name  = "pinctrl-menu-option";
          patch = ./0001-Add-PINCTRL-back-in-as-a-menu-option.patch; }
      ] ++ drv.kernelPatches;
      extraConfig = ''
        GPIOLIB y
        PINCTRL y
        PINCTRL_BAYTRAIL y
        X86_INTEL_LPSS y
      '';
    });
  };
}
