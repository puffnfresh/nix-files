{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>
    ];

  boot.loader.gummiboot.enable = true;
  boot.loader.gummiboot.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options iwlwifi 11n_disable=1
  '';

  boot.cleanTmpDir = true;

  time.timeZone = "Australia/Melbourne";

  fonts.enableCoreFonts = true;

  hardware.bluetooth.enable = true;
  networking.hostName = "bmckenna-carbon-nixos";
  networking.hostId = "fd123ef8";

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    file
    gitFull
    htop
    which
    wget

    openconnect
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  services.openssh.enable = true;
  services.thermald.enable = true;

  services.xserver = {
    enable = true;

    vaapiDrivers = [ pkgs.vaapiIntel ];

    desktopManager.gnome3.enable = true;

    # displayManager.gdm.enable = true;
    displayManager.desktopManagerHandlesLidAndPower = false;
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    # windowManager.xmonad.haskellPackages = pkgs.haskell.packages.ghc784;

    monitorSection = ''
      DisplaySize 338 190
    '';

    synaptics.additionalOptions = ''
      Option "VertScrollDelta" "-100"
      Option "HorizScrollDelta" "-100"
    '';
    synaptics.buttonsMap = [ 1 3 2 ];
    synaptics.enable = true;
    synaptics.fingersMap = [ 1 3 2 ];
    synaptics.palmDetect = true;
    synaptics.tapButtons = false;
    synaptics.twoFingerScroll = true;
    synaptics.vertEdgeScroll = false;

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };

  programs.ssh.agentTimeout = "12h";

  users.extraUsers.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
  };
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  programs.zsh.enable = true;
}
