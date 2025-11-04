{ config, lib, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.home.brianmckenna.org/"
    ];
    trusted-public-keys = [
      "cache.home.brianmckenna.org:7mrVpgqZNZqMv+lc+WWTCvEjuWwCfnpR/IdzoRx9jUw="
    ];
    trusted-users = [ "@wheel" ];
  };
  networking.hosts."192.168.1.57" = [
    "hydra.home.brianmckenna.org"
    "cache.home.brianmckenna.org"
  ];

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true;

  networking.hostName = "thoughtless";
  networking.hostId = "29cfe4a5";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Hobart";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.fuse.userAllowOther = true;

  virtualisation.hypervGuest = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };


  services.tailscale.enable = true;

  programs.nix-ld.enable = true;

  users.users.bmckenna = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
      "docker"
      "networkmanager"
    ];
    shell = pkgs.zsh; # config.home-manager.users.bmckenna.programs.zsh.package;
  };

  services.hardware.bolt.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
  services.udisks2.enable = true;
  programs.zsh.enable = true;
  services.openssh.enable = true;

  system.stateVersion = "23.11";
}
