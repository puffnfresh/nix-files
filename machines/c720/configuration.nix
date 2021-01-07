# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/media.nix
      ../modules/users/brian.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "orpington-nixos";
  networking.wireless.enable = true;

  time.timeZone = "Australia/Hobart";

  services.openssh.enable = true;
  # services.openssh.permitRootLogin = "yes";

  system.stateVersion = "18.09";

}
