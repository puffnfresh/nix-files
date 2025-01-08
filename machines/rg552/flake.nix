{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: rec {
    nixosConfigurations.tenacious =
      nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./configuration.nix ];
      };

    hydraJobs =
      let
        toplevel =
          name: nixosConfigurations."${name}".config.system.build.toplevel;
      in
      {
        tenacious = toplevel "tenacious";
      };
  };
}
