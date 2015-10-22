{ stdenv, fetchFromGitHub, mate-common, mate-desktop, makeWrapper,
  autoreconfHook, libtool, glib, intltool, pkgconfig, yelp_tools, which,
  vte, pango, gtk, itstool, libxml2, ncurses, dconf }:

stdenv.mkDerivation rec {
  name = "mate-terminal";
  version = "1.10.1";
  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = name;
    rev = "${name}-${version}";
    sha256 = "0f3k5h088i354y88i70rxfvy4lfg9nmlkynm5vya5b7c6cbgcg8h";
  };
  buildInputs = [
    mate-common mate-desktop makeWrapper autoreconfHook libtool glib intltool
    pkgconfig yelp_tools which vte pango gtk itstool libxml2 ncurses
  ];
  preAutoreconf = ''
    mkdir m4
    intltoolize -f
  '';
  preFixup = ''
    wrapProgram "$out/bin/mate-terminal" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
      --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"
  '';
}
