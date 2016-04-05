with import <nixpkgs> { };

let
  hs = haskell.packages.lts-5_9;
  hawk =
    haskell.lib.dontCheck (hs.callPackage (
      { mkDerivation, base, bytestring, containers, directory, doctest
      , easy-file, exceptions, extra, filepath, haskell-src-exts, hint
      , hspec, HUnit, mtl, network, process, stdenv, stringsearch
      , template-haskell, temporary, test-framework, test-framework-hunit
      , time, transformers
      }:
      mkDerivation {
        pname = "haskell-awk";
        version = "1.1.1";
        src = fetchFromGitHub {
          owner = "gelisam";
          repo = "hawk";
          rev = "5d87ae32a2b58861bdd757832e90e67091256b13";
          sha256 = "0zihqqzj3nscsll19w36vkqfwnhi7h5pwq5bydgy9000q700ik45";
        };
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          base bytestring containers stringsearch
        ];
        executableHaskellDepends = [
          base bytestring containers directory exceptions extra filepath
          haskell-src-exts hint mtl network process stringsearch
          template-haskell time transformers
        ];
        testHaskellDepends = [
          base bytestring containers directory doctest easy-file exceptions
          extra filepath haskell-src-exts hint hspec HUnit mtl network
          process stringsearch template-haskell temporary test-framework
          test-framework-hunit time transformers
        ];
        description = "Transform text from the command-line using Haskell expressions";
        license = stdenv.lib.licenses.asl20;
      }
    ) { });
  ghc = hs.ghcWithPackages (p: [ hawk ]);
in
haskell.lib.overrideCabal hawk (drv: {
  preConfigure = ''
    export HASKELL_PACKAGE_SANDBOXES="${ghc}/lib/ghc-${ghc.version}/package.conf.d"
  '';
})
