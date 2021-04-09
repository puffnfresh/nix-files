{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [ "intel_iommu=on" "kvm.ignore_msrs=1" ];
  boot.kernelModules = [ "vfio_pci" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  virtualisation.kvmgt = {
    enable = true;
    vgpus."i915-GVTg_V5_8".uuid = [ "8f31c8ec-97a5-11eb-9704-7cc3a189833f" ];
  };

  networking.hostName = "tepid";
  networking.hostId = "8337de77";

  time.timeZone = "Australia/Hobart";

  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.interfaces.eth0.useDHCP = true;

  services.xserver.enable = true;
  networking.networkmanager.enable = true;
  programs.sway.enable = true;
  programs.gnupg.agent.enable = true;
  programs.ssh.startAgent = true;
  fonts.fonts = [ pkgs.font-awesome-ttf pkgs.powerline-fonts ];
  virtualisation.libvirtd.enable = true;

  hardware.pulseaudio.enable = true;

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "autojump" "git" ];
      theme = "kennethreitz";
    };
    syntaxHighlighting.enable = true;
  };

  users.users.bmckenna = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
    shell = pkgs.zsh;
  };
  services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  networking.firewall.allowedUDPPorts = [ 4010 ];

  system.stateVersion = "20.09";
}
