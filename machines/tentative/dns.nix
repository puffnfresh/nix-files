{ pkgs, ... }:

{
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = 
      let
        hosts-bl = pkgs.callPackage ./hosts-bl.nix { };
        blacklist = pkgs.runCommand "stevenblack-blocklist-dnsmasq" {
          buildInputs = [ hosts-bl ];
        } ''
          Hosts-BL -i ${pkgs.stevenblack-blocklist}/hosts -f dnsmasq -o $out
        '';
      in {
        server = [ "208.67.220.220" "8.8.4.4" ];
        domain-needed = true;
        bogus-priv = true;
        interface = "br0";
        no-dhcp-interface = "br0";
        bind-dynamic = true;
        conf-file = "${blacklist}";
        address = [
          "/hydra.home.brianmckenna.org/192.168.1.57"
          "/cache.home.brianmckenna.org/192.168.1.57"
          "/reader.home.brianmckenna.org/192.168.1.57"
          "/photos.home.brianmckenna.org/192.168.1.57"
          "/notes.home.brianmckenna.org/192.168.1.57"
          "/media.home.brianmckenna.org/192.168.1.57"
        ];
      };
  };

  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];
}
