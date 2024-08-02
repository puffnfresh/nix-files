{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  home-manager.users.brian = import ./home.nix;

  system.stateVersion = "18.03";

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.cleanOnBoot = true;

  time.timeZone = "Australia/Hobart";
  i18n.defaultLocale = "en_AU.UTF-8";
  networking.hostName = "bmckenna-carbon-nixos";
  networking.hostId = "fd123ef8";
  networking.networkmanager.enable = true;

  services.avahi.enable = true;

  console = {
    packages = [ pkgs.terminus_font ];
    font = "ter-132n";
  };

  services.openssh.enable = true;
  # services.xserver.enable = true;
  # services.xserver.displayManager.sddm.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  services.gnome.gnome-keyring.enable = true;
  programs.gnupg.agent.enable = true;
  # programs.gnupg.agent.pinentryFlavor = "gtk2";
  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
  programs.ssh.startAgent = true;

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.upower.enable = true;
  hardware.pulseaudio.enable = true;
  fonts.packages = [ pkgs.font-awesome pkgs.powerline-fonts ];

  hardware.keyboard.qmk.enable = true;

  # virtualisation.podman.enable = true;

  services.tailscale.enable = true;

  nix.settings.trusted-users = [ "@wheel" ];
  users.extraUsers.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "kennethreitz";
    };
  };
  programs.autojump.enable = true;
  programs.slock.enable = true;
}
