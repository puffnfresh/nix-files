{ pkgs
, ...
}:

{
  services.unifi = {
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-6_0.overrideAttrs (attrs: {
      sconsFlags = attrs.sconsFlags ++ [ "--experimental-optimization=-sandybridge" ];
    });
    openFirewall = true;
    enable = true;
  };	
  networking.firewall.allowedTCPPorts = [ 8443 ];
}
