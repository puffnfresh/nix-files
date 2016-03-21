with import <nixpkgs> { };

## Example

# nix-build \
#   --argstr name "laas" \
#   --argstr src laas_1.3.2_linux_amd64.tar.gz \
#   --argstr entrypoint "/laas_1.3.2_linux_amd64/laas" \
#   dockerise-tar.nix

# docker load -i result

# docker run -v ~/:/root -ti laas service list

let
  alpine = dockerTools.buildImage {
    name = "alpine";
    runAsRoot = ''
      mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
      echo "hosts: files dns myhostname mymachines" > /etc/nsswitch.conf
      ln -s /etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
    '';
    fromImage = dockerTools.buildImage {
      name = "alpine";
      contents = cacert;
      fromImage = dockerTools.pullImage {
        imageName = "alpine";
        imageTag = "3.3";
        sha256 = "0jnwabyfgy3smf3r0hgz1hipjvjaka6asj6byc5acg7rnmx828xh";
      };
    };
  };
in
{ name, src, entrypoint }:
dockerTools.buildImage {
  inherit name;
  fromImage = alpine;
  contents = runCommand "${name}-src" { } ''
    mkdir -p $out
    cd $out
    tar xf ${src}
  '';
  config = {
    Entrypoint = [ entrypoint ];
  };
}

