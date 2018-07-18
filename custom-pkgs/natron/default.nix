{ lib, stdenv, fetchurl, buildFHSUserEnv }:

let
  natron =
    stdenv.mkDerivation rec {
      name = "natron-${version}";
      version = "2.3.13";

      src = fetchurl {
        url = "mirror://sourceforge/natron/Linux/64/releases/Natron-${version}-Linux-x86_64bit-portable.tar.xz";
        sha256 = "1r57g1cfdkrkknm79dyw7lk8m5d9cg3bb9w75p4r0w5isdxcdvj8";
      };

      dontBuild = true;
      installPhase = ''
        mkdir -p $out/share
        mv $PWD $out/share/natron
      '';

      meta = with stdenv.lib; {
        description = "Node-graph based, open-source compositing software";
        longDescription = ''
          Node-graph based, open-source compositing software. Similar in
          functionalities to Adobe After Effects and Nuke by The Foundry.
        '';
        homepage = https://natron.inria.fr/;
        license = stdenv.lib.licenses.gpl2;
        maintainers = [ maintainers.puffnfresh ];
        platforms = platforms.linux;
      };
    };
in
buildFHSUserEnv {
  name = "natron-fhs-env";
  multiPkgs = pkgs: [
    natron

    pkgs.libGL
    pkgs.libGLU
    pkgs.xorg.libICE
    pkgs.xorg.libSM
    pkgs.xorg.libX11
    pkgs.xorg.libXcursor
    pkgs.xorg.libXext
    pkgs.xorg.libXfixes
    pkgs.xorg.libXi
    pkgs.xorg.libXinerama
    pkgs.xorg.libXrandr
    pkgs.xorg.libXrender
    pkgs.zlib
  ];
  runScript = "/usr/share/natron/Natron";
}
