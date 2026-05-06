{
  description = "Kobo Clara 2E (termly) NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      crossPkgs = import nixpkgs {
        system = "x86_64-linux";
        crossSystem = nixpkgs.lib.systems.examples.armv7l-hf-multiplatform;
      };
    in {
      nixosConfigurations.termly = nixpkgs.lib.nixosSystem {
        system = "armv7l-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      packages.x86_64-linux.kernel =
        crossPkgs.callPackage ./pkgs/linux-clara2e.nix {};

      packages.x86_64-linux.uBoot =
        crossPkgs.callPackage ./pkgs/u-boot-clara2e.nix {};

      hydraJobs.kobo-clara-2e =
        self.nixosConfigurations.termly.config.system.build.toplevel;
    };
}
