{ stdenv, makeWrapper, binutils, gcc, pkgconfig, stack
, ghc
, icu, ncurses, zlib
, extraLibs ? [ icu ncurses zlib ]
}:

let
  bins = [
    ghc
    binutils
    gcc
    pkgconfig
  ];
  inherit (stdenv) lib;
in
stdenv.mkDerivation {
  name = "stack-${stack.version}";
  inherit (stack) version;

  buildInputs = [ makeWrapper pkgconfig ] ++ extraLibs;

  buildCommand = ''
    makeWrapper ${stack}/bin/stack $out/bin/stack \
      --prefix PATH : "${lib.makeBinPath bins}" \
      --prefix PKG_CONFIG_PATH : "$PKG_CONFIG_PATH" \
      --prefix LD_LIBRARY_PATH : "'${lib.makeLibraryPath extraLibs}'" \
      --prefix NIX_LDFLAGS ' ' "'$NIX_LDFLAGS'" \
      --prefix NIX_CFLAGS_COMPILE ' ' "'$NIX_CFLAGS_COMPILE'"
  '';
}
