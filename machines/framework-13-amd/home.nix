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

  gtk.gtk4.theme = null;

  home.username = "bmckenna";
  home.homeDirectory = "/home/bmckenna";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
  programs.nix-index.enable = true;

  programs.btop.enable = true;
  programs.direnv.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      term = "xterm-256color";
      allow_remote_control = "yes";
    };
  };
  programs.autojump.enable = true;
  programs.jq.enable = true;
  programs.tmux.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass-wayland;
    settings = { PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store"; };
  };

  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings.user = {
      name = "Brian McKenna";
      email = "brian@brianmckenna.org";
      merge.conflictstyle = "zdiff3";
    };
  };

  programs.chromium = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = [
      # pkgs.vscode-extensions.anthropic.claude-code
      pkgs.vscode-extensions.hashicorp.hcl
      pkgs.vscode-extensions.hashicorp.terraform
      pkgs.vscode-extensions.eamodio.gitlens
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.hashicorp.hcl
      pkgs.vscode-extensions.catppuccin.catppuccin-vsc
      pkgs.vscode-extensions.catppuccin.catppuccin-vsc-icons
      pkgs.vscode-extensions.haskell.haskell
      pkgs.vscode-extensions.justusadam.language-haskell
    ];
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
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

    pkgs.xwayland-satellite-stable
    pkgs.dconf

    (pkgs.writeScriptBin "hours-to-fractions" ''
      #!/usr/bin/env zsh
      TIME="$1"
      HOURS="$(echo "$TIME" | cut -d : -f 1)"
      MINUTES="$(echo "$TIME" | cut -d : -f 2)"
      DECIMALS="$((MINUTES / 60.0))"
      printf "%.2f" "$(("$HOURS" + "$DECIMALS"))"
      echo
    '')
  ];
}
