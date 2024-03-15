{ config, lib, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ];

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 16 * 1024;
    }
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.home.brianmckenna.org/"
    ];
    trusted-public-keys = [
      "cache.home.brianmckenna.org:7mrVpgqZNZqMv+lc+WWTCvEjuWwCfnpR/IdzoRx9jUw="
    ];
    trusted-users = [ "@wheel" ];
  };
  networking.hosts."192.168.1.57" = [
    "hydra.home.brianmckenna.org"
    "cache.home.brianmckenna.org"
  ];

  nix.registry = {
    nixpkgs.to = {
      type = "path";
      path = pkgs.path;
    };
  };

  # boot.kernelModules = [
  #   "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd"
  # ];
  # boot.kernelParams = [
  #   "intel_iommu=on"
  #   "iommu=pt"

  #   # "vfio-pci.ids=10de:25bc,10de:2291" # RTX A1000
  #   # "vfio-pci.ids=10de:13c2,10de:0fbb" # GTX 970
  # ];

  networking.wireguard.interfaces.atlwg0 = {
    ips = [ "192.168.56.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/home/bmckenna/code/atlassian/anyconnect-to-wireguard-scripts/keys/wg-private-key";
    peers = [
      {
        publicKey = "sRERaiw03OTn7SXP6N/BjyuuziicR4UO8qJuluZWThM=";
        allowedIPs = [ "192.168.56.2/32" ];
        endpoint = "192.168.122.2:51820";
      }
    ];
  };

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  # services.xserver.videoDrivers = [ "amdgpu" ];

  networking.hostName = "thoughtless";
  networking.hostId = "29cfe4a5";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Hobart";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  virtualisation.hypervGuest = {
    enable = true;
    videoMode = "1024x768";
  };

  virtualisation.docker = {
    enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      ovmf.packages = [ (pkgs.OVMF.override {
        tpmSupport = true;
        secureBoot = true;
        fdSize4MB = true;
      }).fd ];
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;

  programs.nix-ld.enable = true;

  users.users.bmckenna = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
    ];
    shell = pkgs.zsh; # config.home-manager.users.bmckenna.programs.zsh.package;
  };

  services.hardware.bolt.enable = true;
  programs.hyprland.enable = true; # adds things to xdg.portal
  services.dbus.packages = [ pkgs.gcr ];
  services.udisks2.enable = true;
  programs.zsh.enable = true;
  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.allowedUDPPorts = [ 51820 ];

  system.stateVersion = "23.11";
}
