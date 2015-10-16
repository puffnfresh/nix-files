{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      stdenv = pkgs.stdenv // {
        platform = pkgs.stdenv.platform // {
          kernelExtraConfig = ''
            PINCTRL_BAYTRAIL y
            X86_INTEL_LPSS y
          '';
        };
      };
    };
  };
}
