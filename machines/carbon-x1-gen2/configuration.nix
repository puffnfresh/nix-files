{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      <nixpkgs/nixos/modules/programs/command-not-found/command-not-found.nix>

      ../modules/vpn/client.nix
    ];

  system.stateVersion = "18.03";

  nix = {
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://nixcache.reflex-frp.org"
      "http://hydra.qfpl.io"
      "https://snack.cachix.org"
    ];
    trustedBinaryCaches = [ https://hydra.nixos.org ];
    binaryCachePublicKeys = [
      "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "qfpl.io:xME0cdnyFcOlMD1nwmn6VrkkGgDNLLpMXoMYl58bz5g="
      "snack.cachix.org-1:yWpdDCWeJzVAQUSM1Ol0E3PCVbG4k2wRAsZ/b5L3huc="
    ];
    trustedUsers = [ "@wheel" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = ''
    options iwlwifi 11n_disable=1
  '';

  boot.cleanTmpDir = true;

  time.timeZone = "Asia/Calcutta";

  security.audit.enable = false;

  fonts.enableCoreFonts = true;
  fonts.fonts = [ pkgs.iosevka ];

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl ];
  networking.hostName = "bmckenna-carbon-nixos";
  networking.hostId = "fd123ef8";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 27036 21027 ];
  networking.firewall.allowPing = true;

  puffnfresh.vpn.ip = "10.100.0.3";

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    file
    gitFull
    htop
    which
    wget

    gnome3.dconf
    taffybar

    openconnect
    sshfsFuse
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  services.openssh.enable = true;
  services.upower.enable = true;
  services.thermald.enable = true;

  services.xserver = {
    enable = true;

    autoRepeatDelay = 300;
    autoRepeatInterval = 50;

    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    windowManager.xmonad.extraPackages = (haskellPackages: [
      haskellPackages.taffybar
    ]);

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

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  users.extraUsers.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" ];
  };
  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  programs.zsh.enable = true;
  programs.slock.enable = true;
}
