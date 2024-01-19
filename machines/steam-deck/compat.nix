{ nixpkgs
, jovian-nixos
, flake-compat
}:

let
  flake = src:
    (import flake-compat {
      inherit src;
      nodeOverrides = {
        nixpkgs = flake nixpkgs;
        jovian-nixos = flake jovian-nixos;
      };
    }).defaultNix;
in
(flake ./.).outputs.hydraJobs
