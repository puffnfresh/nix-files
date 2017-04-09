# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
  };

  boot.initrd.luks.devices = [
    { name = "root"; device = "/dev/sda2"; preLVM = true; }
  ];

  networking.hostName = "bmckenna-m3800-nixos"; # Define your hostname.
  networking.extraHosts = ''
    127.0.0.1 bmckenna-m3800-nixos
  '';
  networking.hostId = "10536eae";
  networking.wireless.enable = true;  # Enables wireless.

  networking.firewall.allowedTCPPorts = [ 9696 3389 27036 27037 ];
  networking.firewall.allowedUDPPorts = [ 27031 27036 ];
  networking.firewall.allowPing = true;
  networking.firewall.trustedInterfaces = [ "docker0" ];

  fonts.enableCoreFonts = true;

  time.timeZone = "Australia/Melbourne";

  services.udev.extraHwdb = ''
    # Microsoft Natural Ergonomic Keyboard 4000
    keyboard:usb:v045Ep00DB*
     KEYBOARD_KEY_c022d=pageup
     KEYBOARD_KEY_c022e=pagedown
  '';

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

  # nixpkgs.config.virtualbox.enableExtensionPack = true;
  virtualisation.virtualbox.host.enable = true;

  services.syncthing = {
    enable = true;
    systemService = false;
    useInotify = true;
  };
  services.openssh.enable = true;
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  nixpkgs.config.allowUnfree = true;

  hardware.bumblebee.enable = true;
  hardware.bumblebee.connectDisplay = true;

  services.xserver = {
    enable = true;
    xkbOptions = "ctrl:nocaps";

    videoDrivers = [ "intel" "vesa" ];

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
  };

  users.extraUsers.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "fuse" "vboxusers" ];
  };
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  programs.zsh.enable = true;
}
