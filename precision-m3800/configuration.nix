# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  systemd-with-rules = pkgs: hwdb-rules:
    let
      hwdb-local = pkgs.writeText "70-local.hwdb" hwdb-rules;
    in
    pkgs.systemd.overrideDerivation (drv: {
      preFixup = ''
        ln -s ${hwdb-local} $out/lib/udev/hwdb.d/70-local.hwdb
      '';
    });
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  boot.kernelPackages = pkgs.linuxPackages_4_2;

  hardware.opengl.driSupport32Bit = true;

  boot.initrd.luks.devices = [
    { name = "root"; device = "/dev/sda2"; preLVM = true; }
  ];

  networking.hostName = "bmckenna-m3800-nixos"; # Define your hostname.
  networking.hostId = "10536eae";
  networking.wireless.enable = true;  # Enables wireless.

  fonts.enableCoreFonts = true;

  sound.extraConfig = ''
    defaults.pcm.!card 1
  '';

  time.timeZone = "Australia/Melbourne";

  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: rec {
    systemd = systemd-with-rules pkgs ''
      # Microsoft Natural Ergonomic Keyboard 4000
      keyboard:usb:v045Ep00DB*
       KEYBOARD_KEY_c022d=pageup
       KEYBOARD_KEY_c022e=pagedown
    '';
  };

  environment.systemPackages = with pkgs; [
    file
    gitFull
    htop
    tmux
    which
    wget
    haskellPackages.xmobar
  ];

  virtualisation.docker.enable = true;

  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    xkbOptions = "ctrl:nocaps";

    # videoDrivers = [ "intel" ];
    # videoDrivers = [ "nouveau" ];
    # videoDrivers = [ "nvidia" ];

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
  };

  users.extraUsers.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" ];
  };
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  programs.zsh.enable = true;
}
