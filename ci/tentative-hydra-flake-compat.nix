
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
  hydraJobs = name:
    (flake ../. "machines/${name}").outputs.hydraJobs;
in
hydraJobs "tentative"
  // hydraJobs "steam-deck"
