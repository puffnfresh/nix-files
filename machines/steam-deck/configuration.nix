{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  jovian.devices.steamdeck.enable = true;
  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "brian";
    desktopSession = "gnome";
  };
  programs.steam = {
    enable = true;
    extest.enable = true;
  };

  # hardware.opengl.extraPackages = [
  #   pkgs.rocm-opencl-icd
  # ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "teas";
  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Hobart";

  i18n.defaultLocale = "en_AU.UTF-8";

  nix.registry = {
    nixpkgs.to = {
      type = "path";
      path = pkgs.path;
    };
  };

  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      package = pkgs.oh-my-zsh.overrideAttrs (attrs: {
        src = attrs.src.override {
          # https://github.com/ohmyzsh/ohmyzsh/pull/11935
          rev = "1401137a1adbfbb154ef90b0990a13560cd1e0ec";
          sha256 = "sha256-4MEeZ64gguQ3Tk73eGmRBGignAnbE+k4LtAa0TFSQac=";
        };
      });
      plugins = [ "autojump" "git" ];
      theme = "kennethreitz";
    };
    syntaxHighlighting.enable = true;
  };

  programs.chromium = {
    enable = true;
    extensions = [
      "mnjggcdmjocbbbhaepdhchncahnbgone"
      "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    ];
  };

  users.users.brian = {
    isNormalUser = true;
    description = "Brian McKenna";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    shell = pkgs.zsh;
    packages = [
      pkgs.autojump
      pkgs.btop
      pkgs.chromium
      pkgs.microsoft-edge
      pkgs.discord
      pkgs.element-desktop
      pkgs.gitMinimal
      pkgs.pass
      pkgs.silver-searcher
      pkgs.thunderbird
      pkgs.tmux
      pkgs.microsoft-edge
      # pkgs.yuzu-early-access
      (pkgs.vscode-with-extensions.override {
        vscodeExtensions = [
          pkgs.vscode-extensions.arrterian.nix-env-selector
          pkgs.vscode-extensions.bbenoist.nix
          pkgs.vscode-extensions.eamodio.gitlens
          pkgs.vscode-extensions.haskell.haskell
          pkgs.vscode-extensions.justusadam.language-haskell
        ];
      })
      pkgs.wl-clipboard
    ];
  };

  nixpkgs.config.allowUnfree = true;
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
  networking.hosts."192.168.1.57" = [ "cache.home.brianmckenna.org" ];

  services.openssh.enable = true;

  system.stateVersion = "23.05";
}
