{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }: rec {
    nixosConfigurations = {
      thoughtless = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
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
