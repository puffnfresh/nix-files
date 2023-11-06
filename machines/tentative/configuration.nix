# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ./chat.nix
      ./dns.nix
      ./hydra.nix
      ./media.nix
      ./metrics.nix
      ./unifi.nix
      ./web.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fileSystems."/".options = [ "ssd" "noatime" ];
  fileSystems."/nix".options = [ "ssd" "noatime" ];
  fileSystems."/home".options = [ "ssd" "noatime" ];

  services.iperf3 = {
    enable = true;
    openFirewall = true;
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.

  # boot.loader.grub.device = "/dev/disk/by-id/scsi-36842b2b01604e20026395baf41cf7fca"; # or "nodev" for efi only
  boot.loader.grub.device = "/dev/disk/by-id/scsi-36842b2b01604e2002aac8b340e0d0d63";

  boot.supportedFilesystems = [ "zfs" ];

  networking.hostName = "tentative"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.hostId = "1df9b715";
  networking.resolvconf.useLocalResolver = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.br0.useDHCP = true;

  networking.bridges.br0.interfaces = [
    "eno1"
    "eno2"
    "eno3"
    "eno4"
  ];

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    externalInterface = "br0";
  };

  services.tailscale.enable = true;

  nixpkgs.config.allowUnfree = true;
  networking.firewall.allowedTCPPorts = [ 3260 ];

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.runAsRoot = false;
  # Pass through
  boot.blacklistedKernelModules = [ "nouveau" "snd_hda_intel" ];
  boot.kernelParams = [ "intel_iommu=on" ];
  boot.kernelModules = [ "vfio-pci" ];

  environment.systemPackages = with pkgs; [
    tmux
  ];

  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  users.users.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "libvirtd" ];
  };

}
