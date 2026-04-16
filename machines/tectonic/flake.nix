{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.tectonic = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
