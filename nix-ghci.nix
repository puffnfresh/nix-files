with import <nixpkgs> { };

writeScriptBin "nix-ghci" ''
  #!${stdenv.shell}
  args="$@"
  nix-shell -p "haskellPackages.ghcWithPackages (p: with p; [ $args ])" --command ghci
''
