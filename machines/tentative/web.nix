{ config, pkgs, ... }:

{
  containers.web = {
    config =
      { config, pkgs, ... }:
      {
        security.acme = {
          defaults.email = "brian@brianmckenna.org";
          acceptTerms = true;
          certs."home.brianmckenna.org".extraDomainNames = [
            "chat.home.brianmckenna.org"
          ];
        };
        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedTlsSettings = true;
          virtualHosts = {
            "home.brianmckenna.org" = {
              forceSSL = true;
              default = true;
              enableACME = true;
              locations."/".return = "503";
            };
            "chat.home.brianmckenna.org" = {
              forceSSL = true;
              useACMEHost = "home.brianmckenna.org";
              # locations."/webhooks/".proxyPass = "http://localhost:9000/";
              locations."= /_matrix/client/unstable/org.matrix.msc3575/sync".proxyPass = "http://192.168.100.10:8009";
              locations."~ ^/client/".proxyPass = "http://192.168.100.10:8009";
              locations."~ ^(\/_matrix|\/_synapse\/client)".proxyPass = "http://192.168.100.10:8008";
              # locations."/_matrix".proxyPass = "http://192.168.100.10:8008";
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
              forceSSL = true;
              enableACME = true;
              locations = {
                "/" = {
                  proxyPass = "http://localhost:3005";
                };
              };
            };
            "cache.home.brianmckenna.org" = {
              forceSSL = true;
              enableACME = true;
              locations = {
                "/" = {
                  proxyPass = "http://localhost:5001";
                };
              };
            };
            "reader.home.brianmckenna.org" = {
              forceSSL = true;
              enableACME = true;
              locations = {
                "/" = {
                  proxyPass = "http://192.168.101.11:8082";
                };
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
