{ config, pkgs, ... }:

{
  containers.web = {
    timeoutStartSec = "2m"; # Need a long wait for DNS propagation
    config =
      { config, pkgs, ... }:
      {
        security.acme = {
          acceptTerms = true;
          defaults.email = "brian@brianmckenna.org";
          certs = {
            "home.brianmckenna.org" = {
              domain = "*.home.brianmckenna.org";
              dnsProvider = "dreamhost";
              environmentFile = "/var/lib/dreamhost.env";
              group = config.services.nginx.group;
            };
          };
        };

        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          clientMaxBodySize = "8196M";
          virtualHosts = {
            "home.brianmckenna.org" = {
              default = true;
              locations."/".return = "503";
            };
            "chat.home.brianmckenna.org" = {
              addSSL = true;
              useACMEHost = "home.brianmckenna.org";
              locations."= /_matrix/client/unstable/org.matrix.msc3575/sync".proxyPass = "http://192.168.100.10:8009";
              locations."~ ^/client/".proxyPass = "http://192.168.100.10:8009";
              locations."~ ^(\/_matrix|\/_synapse\/client)".proxyPass = "http://192.168.100.10:8008";
              locations."/.well-known/matrix/server" = {
                return = "200 '{\"m.server\": \"chat.home.brianmckenna.org:443\"}'";
                extraConfig = ''
                  default_type application/json;
                  add_header Access-Control-Allow-Origin *;
                '';
              };
              locations."/.well-known/matrix/client" = {
                return = "200 '{\"m.homeserver\":{\"base_url\":\"https://chat.home.brianmckenna.org\"},\"org.matrix.msc3575.proxy\":{\"url\":\"https://chat.home.brianmckenna.org\"}}'";
                extraConfig = ''
                  default_type application/json;
                  add_header Access-Control-Allow-Origin *;
                '';
              };
            };
            "hydra.home.brianmckenna.org" = {
              addSSL = true;
              useACMEHost = "home.brianmckenna.org";
              locations."/" = {
                proxyPass = "http://localhost:3005";
              };
            };
            "cache.home.brianmckenna.org" = {
              addSSL = true;
              useACMEHost = "home.brianmckenna.org";
              locations."/" = {
                proxyPass = "http://localhost:5001";
              };
            };
            "reader.home.brianmckenna.org" = {
              addSSL = true;
              useACMEHost = "home.brianmckenna.org";
              locations."/" = {
                proxyPass = "http://192.168.101.11:8082";
              };
            };
            "photos.home.brianmckenna.org" = {
              addSSL = true;
              useACMEHost = "home.brianmckenna.org";
              locations."/" = {
                proxyPass = "http://192.168.101.11:2283";
                proxyWebsockets = true;
              };
            };
            "notes.home.brianmckenna.org" = {
              addSSL = true;
              useACMEHost = "home.brianmckenna.org";
              locations."/" = {
                proxyPass = "http://192.168.101.11:3001";
              };
            };
          };
        };
        system.stateVersion = "20.03";
      };
    forwardPorts = [ { hostPort = 80; } { hostPort = 443; } ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
