{ emacs26WithPackages }:

{ layers, themes ? p: [ ] }:

emacs26WithPackages (ps: layers (import ./all-spacemacs-packages.nix ps) ++ themes ps)
