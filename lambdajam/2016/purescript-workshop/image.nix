with import <nixpkgs> { };

let
  diskSize = 10 * 1024;

  user = "pscworkshop";
  home = "/home/${user}";

  workshop = <workshop>;

  examples = {
    pux-starter-app = fetchFromGitHub {
      owner = "alexmingoia";
      repo = "pux-starter-app";
      rev = "7f4a6df9e697b7a2f62ebbd3938b52a8b6d43765";
      sha256 = "0khp5bd9b0qzm3j1fpvmws4xxmyx9mv36g2nqy53y4x1b42m2b6x";
    };
    purescript-pux = fetchFromGitHub {
      owner = "alexmingoia";
      repo = "purescript-pux";
      rev = "d921f696eb3896c18c7c695edbdfafee2e58b902";
      sha256 = "062n3z9g37ccnj3qri6nsmj3wysf7z12w5qs43kqmzx6yj4skcfl";
    };
    cube-composer = fetchFromGitHub {
      owner = "sharkdp";
      repo = "cube-composer";
      rev = "339af600b6b03934d74d4f44fd16a4710ab767e6";
      sha256 = "0rfk3irf2njhi2m5znaysv6x0b1v89hg174spyn6j1kg4ghilmb0";
    };
    multipac = fetchFromGitHub {
      owner = "hdgarrood";
      repo = "multipac";
      rev = "b78c45c0003e608157fe8c3b3888f51fc9de5f29";
      sha256 = "1f49mgbyiysb7i9yjdabjmqv323m3990z0w102biwhmvqaign4la";
    };
    pulp = fetchFromGitHub {
      owner = "bodil";
      repo = "pulp";
      rev = "d04eba869f9475386edd325212d46ff663a8e665";
      sha256 = "17ax4jr33j15q7il29p1l0yfxhlkwx08gpkzjjdx8xpmdzqkc6i7";
    };
  };

  purescriptPackages = callPackage <nixpkgs/pkgs/top-level/node-packages.nix> {
    nodejs = nodejs-5_x;
    self = lib.recursiveUpdate purescriptPackages {
      by-version.readable-stream."2.1.0" = purescriptPackages.by-version.readable-stream."2.0.6";
    };
    # npm2nix <(echo '["purescript-psa", "pulp"]') \
    #   npm.nix
    generated = ./npm.nix;
  };

  atomPackages = callPackage <nixpkgs/pkgs/top-level/node-packages.nix> {
    self = atomPackages;
    # npm2nix <(echo '[{"ide-purescript":"https://github.com/nwolverson/atom-ide-purescript/archive/v0.13.0.tar.gz"}, \
    #   {"linter":"https://github.com/steelbrain/linter/archive/v1.11.4.tar.gz"}, \
    #   {"language-purescript":"https://github.com/purescript-contrib/atom-language-purescript/archive/v0.7.0.tar.gz"}]') \
    #   atom.nix
    generated = ./atom.nix;
  };

  purescript = (haskellPackages.override {
    overrides = self: super: {
      language-javascript = haskell.lib.overrideCabal super.language-javascript_0_6_0_3 (p: {
        version = "0.6.0.4";
        sha256 = "1yz5n01njgfkq352rk01dym42v9jx4x8r7am9yzsbrnvizsqc3l5";
      });
      purescript = haskell.lib.overrideCabal super.purescript (p: {
        version = "0.8.5.0";
        sha256 = "010dsvd4pv51xn17lm44xd3cp961i04ji7gzrsmpjgmk2g8m78km";
        libraryHaskellDepends = p.libraryHaskellDepends ++ [ self.spdx ];
      });
    };
  }).purescript;

  configuration = {
    imports = [ <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix> ];

    boot.loader.timeout = 0;

    environment.systemPackages = [
      atom
      chromium
      gitFull
      purescript
      nodePackages.bower
      purescriptPackages.pulp
      purescriptPackages.purescript-psa
      nodejs
    ];

    services.openssh.enable = true;
    services.xserver = {
      enable = true;
      displayManager.auto = {
        enable = true;
        inherit user;
      };
      desktopManager.xfce.enable = true;
    };

    users.mutableUsers = false;
    users.extraUsers."${user}" = {
      uid = 1000;
      password = "";
      group = "users";
      extraGroups = [ "wheel" "vboxsf" ];
      inherit home;
      useDefaultShell = true;
    };

    system.activationScripts."${user}" = ''
      if [ ! -e ${home} ]; then
        mkdir ${home}
        chmod 0700 ${home}

        mkdir -p ${home}/.atom/packages
        cp -r ${atomPackages.ide-purescript}/lib/node_modules/ide-purescript ${home}/.atom/packages/
        cp -r ${atomPackages.language-purescript}/lib/node_modules/language-purescript ${home}/.atom/packages/
        cp -r ${atomPackages.linter}/lib/node_modules/linter ${home}/.atom/packages/
        chmod -R u+w ${home}/.atom/packages

        cp -r ${workshop} ${home}/workshop
        chmod -R u+w ${home}/workshop

        mkdir ${home}/examples
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path: "cp -r ${path} ${home}/examples/${name}") examples)}
        chmod -R u+w ${home}/examples

        mkdir ${home}/Desktop
        install -m 0755 ${atom}/share/applications/atom.desktop ${home}/Desktop/
        install -m 0755 ${chromium}/share/applications/chromium.desktop ${home}/Desktop/
        ln -s ${home}/examples ${home}/Desktop/examples
        ln -s ${home}/workshop ${home}/Desktop/workshop

        chown -R ${user}:users ${home}
      fi
    '';
  };
in
import <nixpkgs/nixos/lib/make-disk-image.nix> rec {
  name = "nixos-vdi-${config.system.nixosLabel}-${pkgs.stdenv.system}";

  config = (import <nixpkgs/nixos> { inherit configuration; }).config;
  inherit pkgs lib diskSize;
  partitioned = true;

  configFile = pkgs.writeText "configuration.nix"
    ''
      {
        imports = [ <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix> ];
      }
    '';

  postVM =
    ''
      echo "creating VirtualBox disk image..."
      mkdir -p $out
      fn="$out/nixos-${config.system.nixosLabel}-${pkgs.stdenv.system}.vdi"
      ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -O vdi $diskImage $fn
      rm $diskImage
    '';
}
