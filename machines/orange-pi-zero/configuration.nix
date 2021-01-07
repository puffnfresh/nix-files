{ config, pkgs, ... }:

{
  disabledModules = [ "profiles/installation-device.nix" ];
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-armv7l-multiplatform.nix> ];

  nix.binaryCaches = [ "http://nixos-arm.dezgeg.me/channel" ];
  nix.binaryCachePublicKeys = [ "nixos-arm.dezgeg.me-1:xBaUKS3n17BZPKeyxL4JfbTqECsT+ysbDJz29kLFRW0=%" ];

  networking.hostName = "bmckenna-orange-pi-zero-nixos";
  networking.hostId = "24ebc6f2";
  networking.wireless.enable = true;
  security.sudo.enable = true;
  services.openssh.enable = true;
  boot.kernel.sysctl."vm.overcommit_memory" = "1";
  # environment.variables.GC_INITIAL_HEAP_SIZE = "100000";

  users.extraUsers.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://github.com/puffnfresh.keys";
        sha256 = "0gv8wpjxvb18fmvjvlg5ba9phqdhrmyl86qkkv8n7s7kq4dy12di";
      }))
    ];
  };

}
