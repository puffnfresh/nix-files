# Windows 11, build 22000 with WSL

{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  programs.autojump.enable = true;
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.tmux.enable = true;

  programs.git = {
    enable = true;
    userName = "Brian McKenna";
    userEmail = "brian@brianmckenna.org";
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-wsl-ps1;
  };

  programs.gpg.enable = true;

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (p: [
      (pkgs.callPackage ./pass-extension-wclip.nix { })
    ]);
  };

  news.display = "silent";
  home.packages = [
    pkgs.home-manager

    pkgs.mg
    pkgs.silver-searcher
    pkgs.openssh
    pkgs.file
    pkgs.mtr
    pkgs.which
    pkgs.wget
  ];
}
