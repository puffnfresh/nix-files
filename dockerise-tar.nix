with import <nixpkgs> { };

## Example

# nix-build \
#   --argstr name "laas" \
#   --argstr src laas_1.3.2_linux_amd64.tar.gz \
#   --argstr entrypoint "/laas_1.3.2_linux_amd64/laas" \
#   dockerise-tar.nix

# docker load -i result

# docker run -v ~/:/root -ti laas service list

{ name, src, entrypoint }:
dockerTools.buildImage {
  inherit name;
  fromImage = import ./alpine.nix;
  contents = runCommand "${name}-src" { } ''
    mkdir -p $out
    cd $out
    tar xf ${src}
  '';
  config = {
    Entrypoint = [ entrypoint ];
  };
}

