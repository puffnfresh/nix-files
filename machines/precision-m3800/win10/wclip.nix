{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wclip-${version}";
  version = "1.0";
  src = fetchurl {
    url = "https://github.com/palortoff/wclip/releases/download/v1.0/wclip.exe";
    sha256 = "16k7z224k8vz2vhpdrkxa2c5g27g3g6zn45ng4cvx65f995gq7da";
  };
  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    bin=$out/bin/wclip.exe
    cp $src $bin
    chmod +x $bin
  '';
}
