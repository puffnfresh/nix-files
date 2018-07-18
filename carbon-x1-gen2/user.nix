with import <nixpkgs> { };

{
  inherit (pkgs)
    # steam
    AgdaStdlib
    arandr
    aria2
    aspell
    atool
    autojump
    awscli
    cabal-install
    cabal2nix
    chromium
    coq
    dtrx
    emacs
    evince
    gnupg1compat
    imagemagick
    inotify-tools
    jq
    kdenlive
    keepassx
    kitty
    libnotify
    lsof
    maim
    marp
    mplayer
    nix-du
    oraclejdk
    pandoc
    pavucontrol
    psmisc
    pv
    rofi
    rofi-pass
    silver-searcher
    sshuttle
    tmux
    unrar
    unzip
    xclip
    xlockmore
    ;
  inherit (bind)
    dnsutils
    ;
  inherit (gnome3)
    adwaita-icon-theme
    ;
  inherit (coqPackages)
    ssreflect
    ;
  inherit (haskellPackages)
    Agda
    editpipe
    ghcid
    hlint
    pointfree
    stylish-haskell
    ;
  inherit (xorg)
    xmessage
    ;

  ghc = pkgs.haskellPackages.ghcWithPackages (p: [ p.aeson p.network p.lens p.lens-aeson ]);

  set-brightness = writeShellScriptBin "set-brightness" ''
    echo "$(cat /sys/class/backlight/intel_backlight/max_brightness) / 100 * $1" | \
      ${bc}/bin/bc > /sys/class/backlight/intel_backlight/brightness
  '';

  pass = pkgs.pass.withExtensions (p: [ p.pass-import ]);

  vscode = import ./vscode { inherit pkgs; };
}
