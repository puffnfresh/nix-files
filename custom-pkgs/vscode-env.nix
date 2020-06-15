with import <nixpkgs> { };

buildFHSUserEnv {
  name = "code";
  targetPkgs = p: [
    p.vscode

    # vscode-hie-server
    p.zlib
    p.gmp
    p.ncurses5

    # live share
    p.openssl
    p.icu
    p.libsecret
    p.curl
    p.gnome3.gnome-keyring
  ];
  runScript = "/usr/bin/code $@";
}
