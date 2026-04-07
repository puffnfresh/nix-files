{ config, lib, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = {
    auto-optimise-store = true;
    connect-timeout = 5;
    min-free = 128000000;
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.home.brianmckenna.org/"
    ];
    trusted-public-keys = [
      "cache.home.brianmckenna.org:7mrVpgqZNZqMv+lc+WWTCvEjuWwCfnpR/IdzoRx9jUw="
    ];
    trusted-users = [ "@wheel" ];
  };

  fonts.enableDefaultPackages = true;
  fonts.fontconfig.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  hardware.keyboard.zsa.enable = true;

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  nixpkgs.config.allowUnfree = true;

  hardware.graphics.enable = true;
  environment.variables.NIXOS_OZONE_WL = "1";

  networking.hostName = "thoughtless";
  networking.hostId = "29cfe4a5";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Hobart";
  # time.timeZone = "Australia/Brisbane";

  xdg.portal = {
    enable = true;
    config.common.default = [ "gnome" ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
  };
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.fuse.userAllowOther = true;

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
    shell = pkgs.zsh;
  };

  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  services.hardware.bolt.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
  services.udisks2.enable = true;
  programs.zsh.enable = true;
  services.openssh.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    rocmOverrideGfx = "11.5.0";
    environmentVariables.OLLAMA_CONTEXT_LENGTH = builtins.toString (32 * 1024);
    host = "0.0.0.0";
    openFirewall = true;
  };

  system.stateVersion = "23.11";
}
