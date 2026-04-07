{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, niri, nixos-hardware, nix-index-database }: rec {
    nixosConfigurations = {
      thoughtless = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          { nixpkgs.overlays = [ niri.overlays.niri ]; }
          # flake-programs-sqlite.nixosModules.programs-sqlite
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          nixos-hardware.nixosModules.framework-amd-ai-300-series
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bmckenna.imports = [
                ./home.nix
                catppuccin.homeModules.catppuccin
                niri.homeModules.niri
                nix-index-database.homeModules.default
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
