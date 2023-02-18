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

  hardware.deviceTree = {
    # Don't need overlays to be compiled, just want to specify name and package.
    enable = false;

    name = "rockchip/rk3399-anbernic-rg552.dtb";

    # Ideally we'd just copy this into the kernel sources and not have to do
    # this manually. But using `overrideDerivation` on the kernel package breaks
    # `override` which is used by `kernelPackages`.
    package =
      let
        original =
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/a95c745242893338941914421b52fecd41879af5/board/batocera/rockchip/rk3399/dts/rk3399-anbernic-rg552.dts";
            sha256 = "sha256-VAHo0YVJ0thjJiJqwxWxMWNR6fjy4kWHoN5RXbxBEV4=";
          };
      in
      pkgs.runCommandCC "rg552-dts" {
        inherit (config.boot.kernelPackages.kernel) src;
        nativeBuildInputs = [ pkgs.dtc ];
      } ''
        unpackPhase
        cd "$sourceRoot"
        DTS=arch/arm64/boot/dts/rk3399-anbernic-rg552.dts
        cp "${original}" "$DTS"
        mkdir -p "$out/rockchip"
        $CC -E -nostdinc -Iinclude -undef -D__DTS__ -x assembler-with-cpp "$DTS" | \
          dtc -I dts -O dtb -@ -o "$out/rockchip/rk3399-anbernic-rg552.dtb"
      '';
  };

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelParams = [
    "console=tty3"
    "console=ttyS2,1500000n8"
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_1;

  boot.kernelPatches =
    let
      rev = "a95c745242893338941914421b52fecd41879af5";
    in
    [
      {
        name = "rg552-config";
        patch = null;
        extraStructuredConfig = {
          DRM = lib.kernel.yes;

          DRM_PANEL_SHARP_LS054B3SX01 = lib.kernel.yes;

          INPUT_JOYSTICK = lib.kernel.yes;
          JOYSTICK_SINGLEADCJOY = lib.kernel.yes;

          # disables media and other things
          EMBEDDED = lib.kernel.yes;
        };
      }
      {
        name = "drivers-gpu-drm-panel-add-rg552-s-panel";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-0000-drivers-gpu-drm-panel-add-rg552-s-panel.patch";
          sha256 = "sha256-CsTNUuvSGMOqwY8xOv8YzFQkVc+ARB69mmWAk8d+MxI=";
        };
      }
      {
        name = "drivers-add_rg552_singleadcjoy";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-0001-drivers-add_rg552_singleadcjoy.patch";
          sha256 = "sha256-dGYRuCtTpmLjQT5JYYpzLgsf1MXqnCGBACs5quIKTjI=";
        };
      }
      {
        name = "rockchip-from-list";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-0002-rockchip-from-list.patch";
          sha256 = "sha256-UqxJpZvIHZggOrQ1vhtXklRn6GGWzkyrpoQKwaS7kyk=";
        };
      }
      {
        name = "drivers-support-chip-RTL8188FU";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-0003-drivers-support-chip-RTL8188FU.patch";
          sha256 = "sha256-mOfL7he1s6FhqipAvOy1aKMbUFmcZUouX400GVF/LaM=";
        };
      }
      {
        name = "rename_cw2015_battery";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-0003-rename_cw2015_battery.patch";
          sha256 = "sha256-NTXKAEtLnqN98sjTYtCETCVNYQ2JKVQbpiEDwYj6aes=";
        };
      }
      {
        name = "net-phy-add-support-for-motorcomm-yt8531c-phy";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-0008-net-phy-add-support-for-motorcomm-yt8531c-phy.patch";
          sha256 = "sha256-Tp4N9WJ4TxWL94s96cJ9hiNryH8AhYzmEn8bcc1b9Ag=";
        };
      }
      {
        name = "v4l2-from-list";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-0011-v4l2-from-list.patch";
          sha256 = "sha256-C0uXIpwQgH1LDBWb03PWXqFpMw0Mdk0YRKn/4mR6YcE=";
        };
      }
      {
        name = "drm-from-list";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-0020-drm-from-list.patch";
          sha256 = "sha256-ZncPuSf8U7FUaxLlN2A1QbjferhFvu1SSr7SqFgnkws=";
        };
      }
      {
        name = "drm-rockchip";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-1000-drm-rockchip.patch";
          sha256 = "sha256-5Zy5pnlqs5/HeRSBqHoyzbK+Wk21hVNOUN+snMi9pyo=";
        };
      }
      {
        name = "v4l2-rockchip";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-1001-v4l2-rockchip.patch";
          sha256 = "sha256-Ux7q0hBuF+RWap2tC4m3XSQU1HjX47YHGySVpBa0928=";
        };
      }
      {
        name = "for-libreelec";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-1002-for-libreelec.patch";
          sha256 = "sha256-uDz1Mjo+0y6PCnUX+ZPtgC28NP9TdCcUosK1e6TuCGE=";
        };
      }
      # Doesn't apply:
      # {
      #   name = "v4l2-wip-rkvdec-hevc";
      #   patch = pkgs.fetchpatch {
      #     url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-2000-v4l2-wip-rkvdec-hevc.patch";
      #     sha256 = "sha256-4Ph2VBfKE/knWIQz87Hk26esF9JFK0VcBkyFdsuK4Ow=";
      #   };
      # }
      {
        name = "v4l2-wip-iep-driver";
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${rev}/board/batocera/rockchip/rk3399/linux_patches/linux-2001-v4l2-wip-iep-driver.patch";
          sha256 = "sha256-cKJ7HbAG+dg3Tkfiyb8vGhEhp6X2h6ktswXoPXPMg/E=";
        };
      }
    ];

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
