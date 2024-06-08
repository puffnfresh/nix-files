{ pkgs
, ...
}:

{
  services.unifi = {
    unifiPackage = pkgs.unifi;
    mongodbPackage = pkgs.callPackage ./mongodb/4.4.nix {
      sasl = pkgs.cyrus_sasl;
      boost = pkgs.boost179.override { enableShared = false; };
      inherit (pkgs.darwin) cctools;
      inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
    };
    openFirewall = true;
    enable = true;
  };	
  networking.firewall.allowedTCPPorts = [ 8443 ];
}
