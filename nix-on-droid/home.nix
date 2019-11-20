{ pkgs, ... }:

let
  nix-on-droid = import <nix-on-droid> { };
in

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Install and configure software declaratively
  programs.git = {
    enable = true;
    userName = "Brian McKenna";
    userEmail = "brian@brianmckenna.org";
  };

  home.file.".ghci".text = ''
    :set prompt "\ESC[1;34m%s\n\ESC[0;34m> \ESC[m"
  '';

  # Simply install just the packages
  home.packages = with pkgs; [
    # Stuff that you really really want to have
    nix-on-droid.basic-environment
    #  (It's installed twice, first time during the installation with nix-env,
    #   second time here, with higher priority (and updates on rebuilds).
    #   It's for your own safety. You are advised to keep both, it's OK.
    #   Removing one is fine too, but removing both will break your install.)

    htop

    # User-facing stuff that you really really want to have
    # vim  # or some other editor, e.g. nano or neovim
    mg

    # Some common stuff that people expect to have
    #diffutils
    #findutils
    #utillinux
    #tzdata
    #hostname
    #man
    less
    which
    ghc
    tmux
    netcat
    socat
    #gnugrep
    #gnupg
    #gnused
    #gnutar
    #bzip2
    gzip
    #xz
    #zip
    #unzip
  ];

  # Fix locale (perl apps panic without it)
  home.sessionVariables = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    EDITOR = "mg";
    PS1 = "\\[\\e[32m\\]\\W\\[\\e[m\\]$ ";
    DISPLAY = "127.0.0.1:0";
  };
}

# vim: ft=nix
