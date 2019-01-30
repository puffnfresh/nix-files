{ config, pkgs, ... }:

{
  imports =
    [
    ./hardware-configuration.nix
    ../modules/users/brian.nix
    ../modules/vpn/client.nix
    ];

  puffnfresh.vpn.ip = "10.100.0.5";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/mmcblk0";

  sound.enable = true;

  networking.hostName = "lightsussex";
  networking.wireless.enable = true;

  time.timeZone = "Australia/Hobart";

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    synaptics.enable = true;
    desktopManager.mate.enable = true;
  };

  users.extraUsers.kylie = {
    isNormalUser = true;
    uid = 1001;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.nixos.stateVersion = "16.03";

}
