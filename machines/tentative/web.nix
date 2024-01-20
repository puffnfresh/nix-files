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
              locations."/_matrix".proxyPass = "http://192.168.100.10:8008";
              locations."/.well-known/matrix/server" = {
                return = "200 '{\"m.server\": \"chat.home.brianmckenna.org:443\"}'";
                extraConfig = "add_header Content-Type application/json;";
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
          };
        };
        system.stateVersion = "20.03";
      };
    forwardPorts = [ { hostPort = 80; } { hostPort = 443; } ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
