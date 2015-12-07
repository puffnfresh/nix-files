{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      stdenv = pkgs.stdenv // {
        platform = pkgs.stdenv.platform // {
          kernelExtraConfig = ''
            HIGHMEM64G? n
            HIGHMEM4G y
          '';
        };
      };
    };
  };
}
