{ pkgs, ... }:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") { };
in
{
  nixpkgs.overlays = [
    (self: super: {
      wclip = self.callPackage ./wclip.nix { };
    })
  ];

  home.packages = [
    # pkgs.autojump
    pkgs.entr
    pkgs.git-lfs
    pkgs.htop
    pkgs.pandoc
    (pkgs.pass.withExtensions (p: [
      (pkgs.callPackage ./pass-extension-wclip.nix { })
    ]))
    pkgs.silver-searcher
    pkgs.cachix
    # pkgs.weechat
    pkgs.haskellPackages.glirc
    pkgs.dtrx

    (import (builtins.fetchTarball "https://github.com/cachix/ghcide-nix/tarball/master") {}).ghcide-ghc865

    # (all-hies.selection { selector = p: { inherit (p) ghc865; }; })
  ];

  programs.bash = {
    enable = true;
    enableAutojump = true;
    profileExtra = ''
      . ${pkgs.nix}/etc/profile.d/nix.sh

      export PS1="\[\e[30;42m\]\w \[\e[m\]\[\e[30;41m\]\\$\[\e[m\] "
      alias ls='ls --color=auto'
    '';
  };

  programs.git = {
    enable = true;
    userName = "Brian McKenna";
    userEmail = "brian@brianmckenna.org";
  };

  # services.gpg-agent.enable = true;
  # systemd.user.startServices = true;

  programs.tmux = {
    enable = true;
    secureSocket = false;
  };

  programs.keychain.enable = true;
  programs.gpg = {
    # enable = true;
    settings = {
      # pinentry-program = "${pkgs.pinentry}/bin/pinentry";
      # use-agent = false;
    };
  };
}
