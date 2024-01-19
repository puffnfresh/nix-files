
{ nixpkgs
, jovian-nixos
, home-manager
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
      };
    }).defaultNix;
  hydraJobs = name:
    (flake ../. "machines/${name}").outputs.hydraJobs;
in
hydraJobs "tentative"
  // hydraJobs "steam-deck"
  // hydraJobs "thinkpad-p1-gen6"
