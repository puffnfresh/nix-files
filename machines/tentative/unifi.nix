{ pkgs
, ...
}:

{
  services.unifi = {
    unifiPackage = pkgs.unifi;
    mongodbPackage = pkgs.mongodb-7_0.overrideAttrs (attrs: {
      sconsFlags = attrs.sconsFlags ++ [ "--experimental-optimization=-sandybridge" ];
    });
    openFirewall = true;
    enable = true;
  };	
  networking.firewall.allowedTCPPorts = [ 8443 ];
}
