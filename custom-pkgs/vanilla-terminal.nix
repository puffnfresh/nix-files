{ stdenv, fetchFromGitHub, autoreconfHook, intltool, glib, gconf, yelp_tools,
  itstool, libxml2, pkgconfig, gtk, gsettings_desktop_schemas, vte_290,
  gnome2_gtk, python, makeWrapper }:

stdenv.mkDerivation rec {
  name = "vanilla-terminal";
  version = "fc8160c1e98c16a03e10c0212dc6174a6da42b70";
  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = name;
    rev = version;
    sha256 = "0k86a2d15syy8hadainkxx2y6fnra02pqhg308c883hh7rnm0fhk";
  };
  buildInputs = [
    autoreconfHook intltool glib gconf yelp_tools itstool libxml2 pkgconfig gtk
    gsettings_desktop_schemas vte_290 gnome2_gtk python makeWrapper
  ];
  preFixup = ''
    wrapProgram "$out/bin/vanilla-terminal" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --prefix GIO_EXTRA_MODULES : "${gconf}/lib/gio/modules"
  '';
}
