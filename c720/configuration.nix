# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "orpington-nixos";
  networking.wireless.enable = true;

  time.timeZone = "Australia/Hobart";

  services.openssh.enable = true;
  # services.openssh.permitRootLogin = "yes";

  networking.firewall.allowedTCPPorts = [ 8080 ];

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;
  services.xserver.displayManager.lightdm.autoLogin = {
    enable = true;
    user = "brian";
  };

  users.users.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://github.com/puffnfresh.keys";
        sha256 = "0gv8wpjxvb18fmvjvlg5ba9phqdhrmyl86qkkv8n7s7kq4dy12di";
      }))
    ];
  };

  system.stateVersion = "18.09";

}
