{ pkgs
, ...
}:

{
  services.unifi = {
    unifiPackage = pkgs.unifi;
    openFirewall = true;
    enable = true;
  };	
  networking.firewall.allowedTCPPorts = [ 8443 ];
}
