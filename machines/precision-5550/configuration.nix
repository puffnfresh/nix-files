{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.trusted-users = [ "@wheel" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  console.font = "";

  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback
  ];

  networking.hostName = "tepid";
  networking.hostId = "8337de77";

  networking.nat = {
    enable = true;
    internalIPs = [ "169.254.19.76" ];
  };

  time.timeZone = "Australia/Hobart";

  networking.useDHCP = false;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.intel-media-driver ];
    driSupport32Bit = true;
  };
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  networking.networkmanager.enable = true;
  programs.sway.enable = true;
  programs.gnupg.agent.enable = true;
  programs.ssh.startAgent = true;
  fonts.fonts = [ pkgs.font-awesome pkgs.powerline-fonts ];
  services.tailscale.enable = true;

  services.hardware.bolt.enable = true;

  services.printing.enable = true;

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "autojump" "git" ];
      theme = "kennethreitz";
    };
    syntaxHighlighting.enable = true;
  };

  environment.etc."chromium/policies/managed/extra.json".source = builtins.fetchurl {
    url = "https://statlas.prod.atl-paas.net/chromepolicy/113/linux.json";
    sha256 = "sha256:0k9kl2z36cp99vx4qbhgzwz5bg24q2sdxxjrkcb36ckgjkng8y7z";
  };

  users.users.bmckenna = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };
  services.openssh.enable = true;

  services.gvfs.enable = true;

  networking.firewall.allowedTCPPorts = [ 8000 ];
  networking.firewall.allowedUDPPorts = [ 4010 ];

  system.stateVersion = "20.09";
}
