{ pkgs, lib, ... }:

{
  imports = [
    ./home/window-management.nix
  ];

  manual.manpages.enable = false;

  catppuccin = {
    flavor = "mocha";
    starship.enable = true;
    kitty.enable = true;
    btop.enable = true;
  };

  home.username = "bmckenna";
  home.homeDirectory = "/home/bmckenna";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
  programs.btop.enable = true;
  programs.direnv.enable = true;

  programs.kitty = {
    enable = true;
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
    userEmail = "brian@brianmckenna.org";
  };

  programs.chromium = {
    enable = true;
    # bkkmolkhemgaeaeggcmfbghljjjoofoh
    # liecbddmkiiihnedobmlmillhodjkdmb
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = [ pkgs.vscode-extensions.bbenoist.nix ];
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
    settings.add_newline = false;
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
    pkgs.silver-searcher
    pkgs.thunderbird
    pkgs.element-desktop
  ];
}
