{ nixpkgs
, jovian-nixos
}:

let
  flake-compat = src:
    (import (fetchTarball {
      url = "https://github.com/edolstra/flake-compat/archive/0f9255e01c2351cc7d116c072cb317785dd33b33.tar.gz";
    }) { inherit src; }).defaultNix;
  flake =
    (import ./flake.nix).outputs {
      self = flake;
      nixpkgs = flake-compat nixpkgs;
      jovian-nixos = flake-compat jovian-nixos;
    };
in
flake.nixosConfigurations.teas.config.system.build.toplevel
