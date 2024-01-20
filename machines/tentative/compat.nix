{ nixpkgs
, flake-compat
}:

let
  flake = src: dir:
    (import flake-compat {
      inherit src dir;
      nodeOverrides = {
        nixpkgs = flake nixpkgs "";
      };
    }).defaultNix;
in
(flake ../.. "machines/tentative").outputs.hydraJobs
