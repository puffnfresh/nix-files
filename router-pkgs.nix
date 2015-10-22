with (import <nixpkgs/pkgs/stdenv/linux/make-bootstrap-tools-cross.nix> { }).armv5tel;

let
  staticARM = drv: (drv.overrideDerivation (d: {
    postUnpack = ''
        export NIX_CROSS_CFLAGS_LINK="-static $NIX_CROSS_CFLAGS_LINK"
    '';
  })).crossDrv;
in
{
  rsync = staticARM pkgs.rsync;
}
