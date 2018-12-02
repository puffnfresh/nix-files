{ emacs26WithPackages }:

{ layers, themes }:

emacs26WithPackages (ps: layers (import ./all-spacemacs-packages.nix ps) ++ themes ps)
