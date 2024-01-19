{ nixpkgs
, jovian-nixos
}:

let
  flake-compat =
    import (fetchTarball {
      url = "https://github.com/puffnfresh/flake-compat/archive/9de0587e74d16c450bb7fc8779b597d92ed0ef83.tar.gz";
      sha256 = "sha256:1218802ivxyxq453rj54ln9ri6glsxnaaqbc3gg1irqp7a9p2psh";
    });
  flake = src:
    (flake-compat {
      inherit src;
      nodeOverrides = {
        nixpkgs = flake nixpkgs;
        jovian-nixos = flake jovian-nixos;
      };
    }).defaultNix;
in
(flake ./.).outputs.hydraJobs
