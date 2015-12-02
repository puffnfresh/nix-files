with import <nixpkgs> { };

writeScriptBin "nix-ghci" ''
  #!${stdenv.shell}
  packages=""
  for arg in $@; do
    packages="$packages p.$arg"
  done
  nix-shell -p "haskellPackages.ghcWithPackages (p: [$packages ])" --command ghci
''
