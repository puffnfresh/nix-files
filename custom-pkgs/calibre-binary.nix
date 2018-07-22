{ stdenv, fetchurl, makeWrapper, xorg, glib, freetype, fontconfig, libGL }:

let
  libPath =
    stdenv.lib.makeLibraryPath [
      stdenv.cc.cc xorg.libXext xorg.libX11 xorg.libxcb xorg.libICE xorg.libSM
      xorg.libXi xorg.libXrender freetype glib fontconfig xorg.libXcomposite libGL
    ];
in
stdenv.mkDerivation rec {
  name = "calibre-${version}";
  version = "3.28.0";
  src = fetchurl {
    url = "https://github.com/kovidgoyal/calibre/releases/download/v${version}/${name}-x86_64.txz";
    sha256 = "0bz58y5wwjrzj2rw352kcidc1axj3q4ybl4rjxzs5mylqds2yvwr";
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
