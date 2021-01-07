with import <nixpkgs> { };

## Example

# nix-build \
#   --argstr name "laas" \
#   --argstr src "laas_1.3.2_linux_amd64.tar.gz" \
#   --argstr entrypoint "laas" \
#   fhs-tar.nix

# result/bin/laas

{ name, src, entrypoint }:
let
  runScript = stdenv.mkDerivation {
    name = "${name}-runscript";
    inherit src;
    installPhase = ''
      cp -r . $out
    '';
  };
in
buildFHSUserEnv {
  inherit name;
  runScript = "${runScript}/${entrypoint}";
}
