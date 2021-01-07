{ pkgs }:

with pkgs;

let
  hie =
    import (fetchTarball "https://github.com/domenkozar/hie-nix/archive/7f322750f87768254a10cfd5d582e9ba961f2fa7.tar.gz") { inherit pkgs; };
  hieWrapper = writeShellScriptBin "hie" ''
    argv=( "$@" )
    exec nix-shell --pure --run "${hie.hie82}/bin/hie ''${argv[*]}"
  '';
  vscode =
    vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.Nix
      ] ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-hie-server";
          publisher = "alanz";
          version = "0.0.19";
          sha256 = "0x0cs7c5q90p1ffig2wb5v21z3yj3p2chgpvbnlm4gfsnw7qpfzr";
        }
        {
          name = "language-haskell";
          publisher = "justusadam";
          version = "2.5.0";
          sha256 = "10jqj8qw5x6da9l8zhjbra3xcbrwb4cpwc3ygsy29mam5pd8g6b3";
        }
      ];
    };
in
runCommand "${vscode.name}" { nativeBuildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper \
      ${vscode}/bin/code \
      $out/bin/code \
      --prefix PATH : ${lib.makeBinPath [ cabal-install hieWrapper ]}
  ''
