{ lib, pkgs, config, modulesPath, ... }:

{
  wsl = {
    enable = true;
    usbip.enable = true;
    defaultUser = "nixos";
    docker-desktop.enable = true;
  };

  virtualisation.podman.enable = true;
  time.timeZone = "Australia/Hobart";

  networking.hostName = "tactical";

  programs.nix-ld.enable = true;

  nix.settings.trusted-users = [ "nixos" ];
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.overlays = [
    (self: super: {
      pinentry-wsl-ps1 = self.callPackage ./pinentry-wsl-ps1.nix { };
      wclip = self.callPackage ./wclip.nix { };
    })
  ];

  system.stateVersion = "25.05";
}
