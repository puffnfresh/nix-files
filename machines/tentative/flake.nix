{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    puffnfresh-keys = {
      flake = false;
      type = "file";
      url = "https://github.com/puffnfresh.keys?narHash=sha256-GmfwNPhWH6sIfs9wSjQAqw6YzvF0EQwcTnTQ0l1VDPc%3D";
    };
  };

  outputs = { self, nixpkgs, puffnfresh-keys }:
    rec {
      nixosConfigurations = {
        tentative =
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./configuration.nix
              {
                users.users.brian.openssh.authorizedKeys.keys = [ (builtins.readFile puffnfresh-keys) ];
              }
            ];
          };
      };

      hydraJobs =
        let
          toplevel =
            name: nixosConfigurations."${name}".config.system.build.toplevel;
        in
        {
          tentative = toplevel "tentative";
        };
    };
}
