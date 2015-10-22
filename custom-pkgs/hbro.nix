{ stdenv, writeScriptBin, haskellPackages, glib_networking }:

writeScriptBin "hbro" ''
  #!${stdenv.shell}
  export XDG_DATA_DIRS=$GSETTINGS_SCHEMAS_PATH
  export GIO_EXTRA_MODULES=${glib_networking}/lib/gio/modules
  exec ${haskellPackages.hbro}/bin/hbro "$@"
''
