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

  boot.kernelPackages = pkgs.linuxPackages_4_1;

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

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    file
    gitFull
    htop
    tmux
    which
    wget
    haskellPackages.xmobar
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # hardware.nvidiaOptimus.disable = true;

  services.xserver = {
    enable = true;
    xkbOptions = "ctrl:nocaps";

    # videoDrivers = [ "intel" ];
    # videoDrivers = [ "nouveau" ];
    # videoDrivers = [ "nvidia" ];

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.kdm.enable = true;
  # services.xserver.desktopManager.kde4.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  users.extraUsers.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
  };
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  programs.zsh.enable = true;
}
