{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.overlays = [
    (self: super: {
      retroarchBare = super.retroarchBare.overrideAttrs (attrs: {
        patches = attrs.patches ++ [ ./0001-Fallback-to-screensaver-inhibit-via-D-Bus-on-Wayland.patch ];
        buildInputs = attrs.buildInputs ++ [ self.dbus ];
        configureFlags = attrs.configureFlags ++ [ "--enable-dbus" ];
      });
    })
  ];

  networking.hostName = "tenacious";
  networking.hostId = "46a0eaa0";

  hardware.deviceTree.name = "rockchip/rk3399-rg552.dtb";

  boot.extraModprobeConfig = ''
    options 8188fu rtw_ips_mode=0
  '';

  boot.extraModulePackages = [ (config.boot.kernelPackages.callPackage ./rtl8188fu.nix { }) ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelParams = [
    "console=tty3"
    "console=ttyS2,1500000n8"
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_5_18.override {
    modDirVersionArg = "5.18.0-rc3";
    argsOverride = {
      version = "5.18.0-rc3";
      src = pkgs.fetchFromGitHub {
        owner = "R-ARM";
        repo = "kernel";
        rev = "b9fdb84537fc5d2434b79e87c81b9e73125700a1";
        sha256 = "sha256-vsCMoD3YEUmxUv5oSGbvniEj4RRzGPsi8pkPUpsk220=";
      };
    };
    structuredExtraConfig = {
      DRM = lib.kernel.yes;

      DRM_PANEL_SHARP_LS054B3SX01 = lib.kernel.yes;

      INPUT_JOYSTICK = lib.kernel.yes;

      # not sure if these are probed
      ROCKCHIP_MBOX = lib.kernel.yes;
      ROCKCHIP_RGB = lib.kernel.yes;
      ROCKCHIP_RK3066_HDMI = lib.kernel.yes;

      # disables media and other things
      EMBEDDED = lib.kernel.yes;

      # debug statement
      USB_ANNOUNCE_NEW_DEVICES = lib.kernel.yes;
    };
    kernelPatches = [
      {
        name = "force-host-mode";
        patch = ./0002-rg552-force-usbdrd_dwc3_0-to-host-dr_mode.patch;
      }
      {
        name = "drm-separate-panel-orientation";
        patch = ./v3-1-3-gpu-drm-separate-panel-orientation-property-creating-and-value-setting.patch;
      }
      {
        name = "rockchip-gpio-fix-dropped-interrupts";
        patch = ./rockchip-gpio-fix-dropped-interrupts.patch;
      }
    ];
  });

  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = false;
  };

  hardware.pulseaudio.enable = true;

  environment.systemPackages = [
    (pkgs.retroarch.override {
      cores = [ pkgs.libretro.genesis-plus-gx ];
    })
  ];

  environment.etc."machine-info".text = ''
    CHASSIS="tablet"
  '';

  services.xserver = {
    enable = true;
    inputClassSections = [
      ''
        Identifier "Goodix Capacitive TouchScreen"
        MatchIsTouchscreen "on"
        Option "TransformationMatrix" "0 -1 1 1 0 0 0 0 1"
      ''
    ];
    desktopManager.phosh = {
      enable = true;
      user = "brian";
      group = "users";
      phocConfig = {
        xwayland = "true";
        outputs."DSI-1" = {
          scale = 2;
          rotate = "90";
        };
      };
    };
    displayManager.autoLogin = {
      enable = true;
      user = "brian";
    };
    libinput.enable = true;
    xrandrHeads = [
      {
        output = "DSI-1";
        primary = true;
        monitorConfig = ''
          Option "Rotate" "left"
        '';
      }
    ];
    videoDrivers = [ "modesetting" ];
  };

  fileSystems."/run/media/external" = {
    device = "/dev/disk/by-path/platform-fe310000.mmc-part1";
    fsType = "exfat";
    options = [ "nofail" ];
  };

  services.openssh.enable = true;
  users.users.brian = {
    isNormalUser = true;
    password = "nixos";
    extraGroups = [ "wheel" "networkmanager" "input" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://github.com/puffnfresh.keys";
        sha256 = "0gv8wpjxvb18fmvjvlg5ba9phqdhrmyl86qkkv8n7s7kq4dy12di";
      }))
    ];
  };

  services.journald.extraConfig = "Storage=volatile";
}
