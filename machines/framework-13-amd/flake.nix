{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
    flake-programs-sqlite.url = "github:wamserma/flake-programs-sqlite";
    flake-programs-sqlite.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, niri, flake-programs-sqlite }: rec {
    nixosConfigurations = {
      thoughtless = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          flake-programs-sqlite.nixosModules.programs-sqlite
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          # niri.nixosModules.niri
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bmckenna.imports = [
                ./home.nix
                catppuccin.homeManagerModules.catppuccin
                niri.homeModules.niri
              ];
            };
          }
        ];
      };
    };

    hydraJobs.thoughtless =
      nixosConfigurations.thoughtless.config.system.build.toplevel;
  };
}
