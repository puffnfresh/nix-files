let
  pkgsFun = import <nixpkgs>;
  pkgsNoParams = pkgsFun {};

  staticARM = drv: (drv.overrideDerivation (d: {
    buildInputs = d.buildInputs ++ [ pkgs.libcCross.static ];
    postUnpack = ''
      export NIX_CROSS_CFLAGS_LINK="-static $NIX_CROSS_CFLAGS_LINK"
    '';
  })).crossDrv;

  sheevaplugCrossSystem = {
    crossSystem = rec {
      config = "arm-linux-gnueabi";
      bigEndian = false;
      arch = "armv5te";
      float = "soft";
      withTLS = true;
      libc = "glibc";
      platform = pkgsNoParams.platforms.sheevaplug;
      openssl.system = "linux-generic32";
    };
  };
  pkgs = pkgsFun sheevaplugCrossSystem;
in
{
  rsync = staticARM pkgs.rsync;
}
