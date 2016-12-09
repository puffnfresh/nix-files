{ stdenv, fetchurl, makeWrapper, xorg, glib, freetype, fontconfig }:

let
  libPath =
    stdenv.lib.makeLibraryPath [
      stdenv.cc.cc xorg.libXext xorg.libX11 xorg.libxcb xorg.libICE xorg.libSM
      xorg.libXi xorg.libXrender freetype glib fontconfig xorg.libXcomposite
    ];
in
stdenv.mkDerivation rec {
  name = "calibre-${version}";
  version = "2.73.0";
  src = fetchurl {
    url = "https://github.com/kovidgoyal/calibre/releases/download/v${version}/${name}-x86_64.txz";
    sha256 = "036n7a8vd0naw276m0nwnr25i79r2p03wainrcsmfcvv3zd65p8n";
  };
  buildInputs = [ makeWrapper ];
  phases = "installPhase fixupPhase";
  installPhase = ''
    sharePath=$out/share/${name}
    mkdir -p $sharePath
    tar xf $src -C $sharePath
    for i in $(find $sharePath -type f); do
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath "${libPath}" \
        "$i" || true
    done
    makeWrapper $sharePath/calibre $out/bin/calibre \
      --prefix LD_LIBRARY_PATH : ${libPath}
  '';
}
