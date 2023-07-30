{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  system.stateVersion = "18.03";

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;

  boot.supportedFilesystems = [ "zfs" ]; 

  time.timeZone = "Australia/Hobart";
  networking.hostName = "bmckenna-carbon-nixos";
  networking.hostId = "fd123ef8";
  networking.networkmanager.enable = true;

  services.avahi.enable = true;

  console = {
    packages = [ pkgs.terminus_font ];
    font = "ter-132n";
  };

  services.openssh.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  programs.sway.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.pinentryFlavor = "gtk2";
  programs.ssh.startAgent = true;
  xdg.portal.wlr.enable = true;

  services.upower.enable = true;
  hardware.pulseaudio.enable = true;
  fonts.fonts = [ pkgs.font-awesome pkgs.powerline-fonts ];

  virtualisation.podman.enable = true;

  services.tailscale.enable = true;

  nix.trustedUsers = [ "@wheel" ];
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
