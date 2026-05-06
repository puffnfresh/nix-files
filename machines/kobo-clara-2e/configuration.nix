{ pkgs, config, lib, ... }:

let
  uBootClara2e = pkgs.callPackage ./pkgs/u-boot-clara2e.nix {};
  linuxClara2e = pkgs.callPackage ./pkgs/linux-clara2e.nix {};
  firmwareClara2e = pkgs.callPackage ./pkgs/firmware-clara2e.nix {};
in
{
  home-manager.users.brian = import ./home.nix;

  boot.kernelPackages = pkgs.linuxPackagesFor linuxClara2e;
  hardware.firmware = [ firmwareClara2e ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  system.build.uBoot = uBootClara2e;

  networking.hostName = "termly";
  networking.hostId = "0c5cb919";
  networking.interfaces.usb0.useDHCP = true;
  networking.nameservers = [ "1.1.1.1" ];

  zramSwap.enable = true;
  boot.kernel.sysctl."vm.swappiness" = 100;

  documentation.enable = false;
  systemd.coredump.enable = false;
  services.udisks2.enable = false;
  services.accounts-daemon.enable = false;

  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
    IdleAction = "suspend";
  };

  services.getty.autologinUser = "brian";
  environment.loginShellInit = ''
    if [ "$(tty)" = "/dev/tty1" ]; then
      exec koreader
    fi
  '';

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };
  swapDevices = [ ];
  powerManagement.cpuFreqGovernor = "conservative"; # ondemand

  services.journald.extraConfig = "Storage=volatile";

  nix.settings = {
    substituters = [
      "https://cache.tectonic.brianmckenna.org/"
    ];
    trusted-public-keys = [
      "cache.tectonic.brianmckenna.org-1:JJgVJfP+41bQvmahw1MW8hIWkPTsaX2T+19rY5eOXPk="
    ];
    trusted-users = [ "@wheel" ];
  };

  time.timeZone = "Australia/Hobart";

  services.openssh.enable = true;
  services.openssh.startWhenNeeded = true;
  services.openssh.settings.PermitRootLogin = "yes";

  networking.firewall.enable = false;
  networking.wireless.iwd.enable = true;
  hardware.bluetooth.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire.enable = false;

  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttymxc1.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttymxc1 -P h4 -S 1500000";
    };
  };

  environment.systemPackages = [
    pkgs.tmux
    pkgs.htop
    pkgs.koreader
  ];

  users.users.root.password = "nixos";
  users.users.brian = {
    isNormalUser = true;
    password = "nixos";
    extraGroups = [ "wheel" "video" "input" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvy1OOJY0ae+KJBgQ0Ii3NMv5YCfzRJ6Y5LUMNQ4TOcXccIWrbpc3VGifpASEIKnB2jbvjISQImapXKVFExjBEopPc+k83CehnXxsIZZ9jPFpLB28YZ6v0brSiP9DVRURd3SitJcRAQHtTAOC+nHbbTPz4nb44eGxUlCHt1XJPComUxwSihUSUTSZk+el+mdV+wiiYmZ9EboS/4QBn4q28uQHh6C4/XB59pPSmJPoQ47Ea85xBgL5DiAY7GUuyHGRqxIJ/ICOkdQdZKHzi+CmQJHnWE3aWjIKi/jaiOXhd//xpq4128qSryQSj6eWYCIuHfRtmDPOUKXlRpwpECK7Gw=="
    ];
  };

  system.stateVersion = "21.11";
}
