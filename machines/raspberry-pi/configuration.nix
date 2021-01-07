{ lib, config, pkgs, ... }:

{
  imports = [
    ../modules/users/brian.nix

    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-raspberrypi.nix>

    <nixpkgs/nixos/modules/installer/scan/detected.nix>
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixpkgs/nixos/modules/profiles/clone-config.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  disabledModules = [
    <nixpkgs/nixos/modules/profiles/base.nix>
    <nixpkgs/nixos/modules/installer/tools/auto-upgrade.nix>
    <nixpkgs/nixos/modules/tasks/auto-upgrade.nix>
    <nixpkgs/nixos/modules/profiles/installation-device.nix>
    <nixpkgs/nixos/modules/installer/tools/tools.nix>
  ];

  nixpkgs = {
    overlays = [ (self: super: {
      libnl = super.libnl.override { pythonSupport = false; };
      gobject-introspection = super.gobject-introspection.override {
        x11Support = false;
      };
      dbus = super.dbus.override { x11Support = false; };
    }) ];
    config = { };
    crossSystem = lib.systems.elaborate lib.systems.examples.raspberryPi;
    localSystem = { system = "x86_64-linux"; };
  };

  # Things that don't compile or aren't needed
  fonts.fontconfig.enable = false;
  documentation.enable = false;
  security.polkit.enable = false;
  boot.supportedFilesystems = [ "vfat" ];
  services.udisks2.enable = false;
  xdg.mime.enable = false;

  networking.wireless = {
    enable = true;
    networks = {
      honors = { };
      Bilby = { };
    };
  };

  services.openssh.enable = true;

  environment.systemPackages = [
    pkgs.tmux
    pkgs.lynx
  ];
}
