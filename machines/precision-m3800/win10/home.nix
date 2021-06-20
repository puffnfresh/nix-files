{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      pinentry-wsl-ps1 = self.callPackage ./pinentry-wsl-ps1.nix { };
      wclip = self.callPackage ./wclip.nix { };
    })
  ];

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = null;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry-wsl-ps1}
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
    pkgs.which
  ];
}
