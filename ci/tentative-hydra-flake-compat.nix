
{ nixpkgs
, jovian-nixos
, home-manager
, flake-programs-sqlite
, flake-utils
, flake-compat
}:

let
  flake = src: dir:
    (import flake-compat {
      inherit src dir;
      nodeOverrides = {
        nixpkgs = flake nixpkgs "";
        jovian-nixos = flake jovian-nixos "";
        home-manager = flake home-manager "";
        flake-programs-sqlite = flake flake-programs-sqlite "";
        flake-utils = flake flake-utils "";
      };
    }).result;
  hydraJobs = name:
    (flake ../. "machines/${name}").outputs.hydraJobs;
in
hydraJobs "tentative"
  // hydraJobs "steam-deck"
  // hydraJobs "thinkpad-p1-gen6"
