{
  description = "Kobo Clara 2E (termly) NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      crossPkgs = import nixpkgs {
        system = "x86_64-linux";
        crossSystem = nixpkgs.lib.systems.examples.armv7l-hf-multiplatform;
      };
    in {
      nixosConfigurations.termly = nixpkgs.lib.nixosSystem {
        system = "armv7l-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      packages.x86_64-linux.kernel =
        crossPkgs.callPackage ./pkgs/linux-clara2e.nix {};

      packages.x86_64-linux.uBoot =
        crossPkgs.callPackage ./pkgs/u-boot-clara2e.nix {};

      packages.armv7l-linux.uBoot =
        self.nixosConfigurations.termly.pkgs.callPackage ./pkgs/u-boot-clara2e.nix {};

      packages.armv7l-linux.image =
        let
          targetPkgs = self.nixosConfigurations.termly.pkgs;
          rootfs = import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
            inherit (self.nixosConfigurations.termly) config;
            inherit (nixpkgs) lib;
            pkgs = targetPkgs;
            partitionTableType = "legacy";
            format = "raw";
            diskSize = "auto";
            additionalSpace = "1024M";
          };
        in targetPkgs.runCommand "termly.img" {} ''
          cp ${rootfs}/nixos.img $out
          chmod +w $out
          dd if=${self.packages.armv7l-linux.uBoot}/u-boot.imx \
             of=$out bs=1k seek=1 conv=notrunc
        '';

      hydraJobs.kobo-clara-2e =
        self.nixosConfigurations.termly.config.system.build.toplevel;
    };
}
