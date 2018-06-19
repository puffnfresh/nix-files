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
    ghc
    kitty
    gnupg1compat
    imagemagick
    inotify-tools
    jq
    keepassx
    libnotify
    lsof
    maim
    marp
    mplayer
    oraclejdk
    pandoc
    pavucontrol
    psmisc
    pv
    rofi
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

  set-brightness = writeShellScriptBin "set-brightness" ''
    echo "$(cat /sys/class/backlight/intel_backlight/max_brightness) / 100 * $1" | \
      ${bc}/bin/bc > /sys/class/backlight/intel_backlight/brightness
  '';

  vscode = import ./vscode { inherit pkgs; };
}
