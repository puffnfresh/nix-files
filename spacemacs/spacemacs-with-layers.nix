{ emacs26WithPackages }:

f: emacs26WithPackages (ps: f (import ./all-spacemacs-packages.nix ps))
