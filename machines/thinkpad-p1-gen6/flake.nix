{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-programs-sqlite.url = "github:wamserma/flake-programs-sqlite";
    flake-programs-sqlite.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, flake-programs-sqlite }: rec {
    nixosConfigurations = {
      thoughtless = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          flake-programs-sqlite.nixosModules.programs-sqlite
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bmckenna = import ./home.nix;
            };
          }
        ];
      };
    };

    hydraJobs.thoughtless =
      nixosConfigurations.thoughtless.config.system.build.toplevel;
  };
}
