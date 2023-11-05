{
  description = "puffnfresh's Steam Deck flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, jovian-nixos }:
    rec {
      nixosConfigurations = {
        teas =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              jovian-nixos.nixosModules.default
              ./configuration.nix
            ];
          };
      };

      hydraJobs =
        let
          toplevel =
            name: nixosConfigurations."${name}".config.system.build.toplevel;
        in
        {
          steam-deck = toplevel "teas";
        };
    };
}
