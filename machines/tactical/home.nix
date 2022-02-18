# Windows 11, build 22000 with WSL

{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      pinentry-wsl-ps1 = self.callPackage ./pinentry-wsl-ps1.nix { };
      wclip = self.callPackage ./wclip.nix { };
    })
  ];

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
    pinentryFlavor = null;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-wsl-ps1}/bin/pinentry-wsl-ps1.sh
    '';
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
