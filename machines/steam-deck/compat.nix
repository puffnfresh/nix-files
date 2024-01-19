{ nixpkgs
, jovian-nixos
, flake-compat
}:

let
  flake = src: dir:
    (import flake-compat {
      inherit src dir;
      nodeOverrides = {
        nixpkgs = flake nixpkgs "";
        jovian-nixos = flake jovian-nixos "";
      };
    }).defaultNix;
in
(flake ../.. "machines/steam-deck").outputs.hydraJobs
