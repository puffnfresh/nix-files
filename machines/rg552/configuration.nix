{ config, lib, pkgs, ... }:

let
  batoceraRev = "4ae3933bbde7ef294d12baac7d43ea50fb9a3c41";
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    substituters = [
      "https://cache.tectonic.brianmckenna.org/"
    ];
    trusted-public-keys = [
      "cache.tectonic.brianmckenna.org-1:JJgVJfP+41bQvmahw1MW8hIWkPTsaX2T+19rY5eOXPk="
    ];
    trusted-users = [ "@wheel" ];
  };

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
            url = "https://raw.githubusercontent.com/batocera-linux/batocera.linux/${batoceraRev}/board/batocera/rockchip/rk3399/dts/rk3399-anbernic-rg552.dts";
            sha256 = "sha256-VAHo0YVJ0thjJiJqwxWxMWNR6fjy4kWHoN5RXbxBEV5=";
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

  # boot.kernelPackages = pkgs.linuxPackages_6_1;

  boot.kernelPatches =
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
        name = "linux-0002-drivers-add-rg552-singleadcjoy";
        patch = ./linux-0002-drivers-add-rg552-singleadcjoy.patch;
      }
      # {
      #   name = "singleadcjoy-defer-probe";
      #   patch = ./singleadcjoy-defer-probe.patch;
      # }
    ] ++ builtins.map (p: {
      name = builtins.elemAt (pkgs.lib.splitString "." (builtins.baseNameOf p.url)) 0;
      patch = pkgs.fetchpatch p;
    }) (import ./batocera-linux-patches.nix);

  networking.networkmanager = {
    enable = true;
    wifi.scanRandMacAddress = false;
  };

  environment.systemPackages = [
    pkgs.gitMinimal
    (pkgs.retroarch.withCores (cores: [
      cores.genesis-plus-gx
    ]))
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
          rotate = "270";
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

  system.stateVersion = "23.05";
}
