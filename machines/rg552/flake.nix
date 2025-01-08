{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.tenacious =
      nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./configuration.nix ];
      };
  };
}
