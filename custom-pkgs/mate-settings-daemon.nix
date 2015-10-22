{ stdenv, fetchFromGitHub, mate-common, mate-desktop, autoreconfHook, glib,
  intltool, pkgconfig, gtk, dbus_glib, dconf, libxklavier, libmatekbd }:

stdenv.mkDerivation rec {
  name = "mate-settings-daemon";
  version = "1.10.2";
  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = name;
    rev = "${name}-${version}";
    sha256 = "18wzaxf8p9pl7aby90v1k099s3ww3rcnhrr52ipvikzpzgjhwc2d";
  };
  buildInputs = [
    mate-common mate-desktop autoreconfHook glib intltool pkgconfig gtk
    dbus_glib dconf libxklavier libmatekbd
  ];
  preAutoreconf = ''
    mkdir m4
    intltoolize -f
  '';
}
