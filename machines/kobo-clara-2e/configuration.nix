{ pkgs, config, lib, ... }:

{
  imports = [
    (import <mobile-nixos/lib/configuration.nix> { device = "kobo-clara-2e"; })
    <home-manager/nixos>
  ];

  home-manager.users.brian = import ./home.nix;

  nixpkgs.overlays = [ (self: super: {
    xorg = super.xorg.overrideScope (self': super': {
      xorgserver = super'.xorgserver.overrideAttrs (attrs: {
        patches = attrs.patches ++ [
          (pkgs.fetchpatch {
            url = "https://github.com/mirror/xserver/commit/db9e9d45e8ba73510f11eb9e534c176102f6623e.patch";
            sha256 = "sha256-Eg1Eqv1e9L/CCncvyAVSe18c3jNXNxPV36OJuwIC42Y=";
          })
        ];
      });
    });
  }) ];

  mobile.enable = true;
  mobile.boot.stage-1.gui.enable = false;
  hardware.firmware = [ config.mobile.device.firmware ];

  system.build.initialRamdisk = lib.mkForce (pkgs.runCommandNoCC "nullInitialRamdisk" {} "touch $out");

  networking.hostName = "termly";
  networking.hostId = "0c5cb919";
  networking.interfaces.usb0.useDHCP = true;
  networking.nameservers = [ "1.1.1.1" ];

  services.xserver = {
    enable = true;
    dpi = 256;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+xsession";
      session = [ { manage = "window"; name = "xsession"; start = "false"; } ];
      autoLogin = {
        enable = true;
        user = "brian";
      };
    };
    monitorSection = ''Option "Rotate" "left"'';
    inputClassSections = [
      ''
        Identifier "Coordinate Transformation Matrix"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        MatchDriver "libinput"
        Option "CalibrationMatrix" "-1 0 1 0 1 0 0 0 1"
      ''
    ];
    libinput.enable = true;
    videoDrivers = [ "modesetting" ];
  };

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
      "http://cache.armv7l.xyz"
    ];
    trusted-public-keys = [
      "cache.armv7l.xyz-1:kBY/eGnBAYiqYfg0fy0inWhshUo+pGFM3Pj7kIkmlBk="
      "cache.tectonic.brianmckenna.org-1:JJgVJfP+41bQvmahw1MW8hIWkPTsaX2T+19rY5eOXPk="
    ];
    trusted-users = [ "@wheel" ];
  };

  time.timeZone = "Australia/Hobart";

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  networking.firewall.enable = false;
  services.connman.enable = true;
  sound.enable = false;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
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
  ];

  users.users.root.password = "nixos";
  users.users.brian = {
    isNormalUser = true;
    password = "nixos";
    extraGroups = [ "wheel" "video" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://github.com/puffnfresh.keys";
        sha256 = "0gv8wpjxvb18fmvjvlg5ba9phqdhrmyl86qkkv8n7s7kq4dy12di";
      }))
    ];
  };

  system.stateVersion = "21.11";
}
