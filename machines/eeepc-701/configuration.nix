{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

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

  networking.hostName = "tesseract";
  networking.wireless.enable = true;
  networking.firewall.enable = false;
  networking.nat = {
    enable = true;
    externalInterface = "wlp1s0";
    internalInterfaces = [ "enp3s0" ];
  };

  time.timeZone = "Australia/Hobart";

  services.openssh.enable = true;

  users.extraUsers.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/puffnfresh.keys";
        # sha256 = "0gv8wpjxvb18fmvjvlg5ba9phqdhrmyl86qkkv8n7s7kq4dy12di";
      })
    ];
  };

  system.stateVersion = "16.03";
}
