{
  description = "puffnfresh's personal Nix Flake, mainly for Hydra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    mobile-nixos = {
      url = "github:puffnfresh/mobile-nixos/hydra";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, mobile-nixos, home-manager }:
    rec {
      nixosConfigurations = {
        termly =
          nixpkgs.lib.nixosSystem {
            system = "armv7l-linux";
            modules = [
              ./machines/kobo-clara-2e/configuration.nix
              (import "${mobile-nixos}/lib/configuration.nix" { device = "kobo-clara-2e"; })
              home-manager.nixosModules.home-manager
            ];
          };
        tenacious =
          nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./machines/rg552/configuration.nix
            ];
          };
      };

      hydraJobs = {
        kobo-clara-2e = nixosConfigurations.termly.config.system.build.toplevel;
        anbernic-rg552 = nixosConfigurations.tenacious.config.system.build.toplevel;
      };
    };
}
