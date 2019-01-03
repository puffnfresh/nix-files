{
  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.nat = {
    enable = true;
    internalInterfaces = [ "wg0" ];
    externalInterface = "ens3";
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/var/lib/wg/private.key";
      peers = [
        {
          publicKey = "/OPjL3wDIlI94kefvSwoez3lgQytvELfT7nQdmXGTWk=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          publicKey = "o3gEKCX3a5apIWZTAtcNM+T17mAznRY6CHZenFFxUEE=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
        {
          publicKey = "QtjAfY1Fd06U2ZYRhs+Ku/E6hOpOmIwFwyV8myRKp1U=";
          allowedIPs = [ "10.100.0.4/32" ];
        }
      ];
    };
  };
}
