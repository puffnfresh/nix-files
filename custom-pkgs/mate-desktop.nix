{ stdenv, fetchFromGitHub, mate-common, autoreconfHook, pkgconfig, glib,
  intltool, dconf, gobjectIntrospection, libX11, gtk, gtk_doc, yelp_tools,
  itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "mate-desktop";
  version = "1.10.2";
  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = name;
    rev = "${name}-${version}";
    sha256 = "1q1n3nvgs7qzl02mi709p9g9dn2nyqi24pl2m3nmnk68w99xnhz5";
  };
  buildInputs = [
    mate-common autoreconfHook pkgconfig glib intltool dconf
    gobjectIntrospection libX11 gtk gtk_doc yelp_tools itstool libxml2
  ];
  preAutoreconf = ''
    mkdir m4
    intltoolize -f
    gtkdocize
  '';
}
