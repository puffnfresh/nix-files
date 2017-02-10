with import <nixpkgs> { };

let
  version = "1.0.18-20170209170023.17b641d";
  keybase-bin =
    stdenv.mkDerivation {
      name = "keybase-${version}";
      inherit version;
      src = fetchurl {
        url = "https://s3.amazonaws.com/prerelease.keybase.io/linux_binaries/deb/keybase_${version}_amd64.deb";
        sha256 = "01mr6hyzs208g3ankl4swikna66n85xzn7ig4k7p6hxmnnvplgb3";
      };
      phases = ["unpackPhase" "installPhase"];
      unpackPhase = ''
        ar xf $src
        tar xf data.tar.xz
      '';
      installPhase = ''
        mkdir $out
        mv usr/* $out/
        mv {opt,etc} $out/
      '';
    };
in
buildFHSUserEnv {
  name = "keybase-env-${version}";
  targetPkgs = pkgs: with pkgs; [
    alsaLib
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gnome2.GConf
    gtk2
    nspr
    nss
    pango
    systemd
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst

    keybase-bin
  ];
  extraBuildCommands = ''
    ln -s ${keybase-bin}/opt $out/opt
  '';
  runScript = "bash";
}
