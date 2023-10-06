{
  description = "puffnfresh's personal Nix Flake, mainly for Hydra";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    mobile-nixos = {
      url = "github:puffnfresh/mobile-nixos/hydra";
      flake = false;
    };
    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, mobile-nixos, home-manager, jovian-nixos }:
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
        tectonic =
          nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./machines/tectonic/configuration.nix
            ];
          };
        teas =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              jovian-nixos.nixosModules.default
              ./machines/steam-deck/configuration.nix
            ];
          };
      };

      hydraJobs =
        let
          toplevel =
            name: nixosConfigurations."${name}".config.system.build.toplevel;
        in
        {
          kobo-clara-2e = toplevel "termly";
          anbernic-rg552 = toplevel "tenacious";
          oci-compute-instance = toplevel "tectonic";
        };
    };
}
