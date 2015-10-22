{ stdenv, fetchFromGitHub, autoreconfHook, glib, intltool, pkgconfig, gtk, libxklavier }:

stdenv.mkDerivation rec {
  name = "libmatekbd";
  version = "1.10.0";
  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = name;
    rev = "${name}-${version}";
    sha256 = "01qvjnbyb07ikh5ipl04c3w9cnrqja55pds96ajkl6b8m4zn0x38";
  };
  buildInputs = [
    autoreconfHook glib intltool pkgconfig gtk libxklavier
  ];
  preAutoreconf = ''
    mkdir m4
    intltoolize -f
  '';
}
