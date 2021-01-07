with import <nixpkgs> { };

runCommand "run-binary" {
  preferLocalBuild = true;
  allowSubstitutes = false;
} ''
  mkdir -p $out/bin
  cat <<EOF > $out/bin/run-binary
  #!/bin/sh
  $(< $NIX_CC/nix-support/dynamic-linker) \$@
  EOF
  chmod +x $out/bin/run-binary
''
