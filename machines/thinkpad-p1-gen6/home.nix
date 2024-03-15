{ pkgs, lib, ... }:

{
  imports = [
    ./home/window-management.nix
  ];

  manual.manpages.enable = false;

  home.username = "bmckenna";
  home.homeDirectory = "/home/bmckenna";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
  programs.btop.enable = true;

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    extraConfig = ''
      term xterm-256color
    '';
  };
  programs.autojump.enable = true;
  programs.jq.enable = true;
  programs.tmux.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass-wayland;
  };

  programs.git = {
    enable = true;
    userName = "Brian McKenna";
    userEmail = "bmckenna@atlassian.com";
  };

  programs.chromium = {
    enable = true;
    # bkkmolkhemgaeaeggcmfbghljjjoofoh
    # liecbddmkiiihnedobmlmillhodjkdmb
  };

  programs.vscode = {
    enable = true;
    extensions = [ pkgs.vscode-extensions.bbenoist.nix ];
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      # theme = "kennethreitz";
    };
    syntaxHighlighting.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      palette = "catppuccin_mocha";
    } // builtins.fromTOML (builtins.readFile
      (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "starship";
        rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
        sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
      } + "/palettes/mocha.toml")
    );
  };

  programs.firefox.enable = true;
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };

  accounts.email.accounts.brianmckenna = {
    address = "brian@brianmckenna.org";
    realName = "Brian McKenna";
    primary = true;
    thunderbird = {
      enable = true;
      profiles = [ "default" ];
    };
    userName = "brian@brianmckenna.org";
    imap = {
      port = 993;
      host = "mail.brianmckenna.org";
    };
    smtp = {
      port = 465;
      host = "mail.brianmckenna.org";
    };
  };

  home.packages = [
    pkgs.dtrx
    pkgs.file
    pkgs.killall
    pkgs.mg
    pkgs.pavucontrol
    pkgs.remmina
    pkgs.silver-searcher
    pkgs.slack
    pkgs.spotify
    pkgs.thunderbird
    pkgs.zoom-us
  ];
}
