{ ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = "brian@brianmckenna.org";
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/lib/nix-serve/cache_ed25519";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "brianmckenna.org" = {
        addSSL = true;
        enableACME = true;
        root = "/var/www/brianmckenna.org";
        extraConfig = ''
          rewrite ^/fp-course$ https://www.youtube.com/playlist?list=PLly9WMAVMrayYo2c-1E_rIRwBXG_FbLBW;
          rewrite ^/$ https://brianmckenna.org/blog/ redirect;

          rewrite ^/blog/$ /blog/generated/index.htm;
          rewrite ^/blog/feed$ /blog/generated/feed.xml;
          rewrite ^/blog/feed.xml$ /blog/generated/feed.xml;
          rewrite ^/blog/([0-9a-z_]+)$ /blog/generated/$1.htm;
        '';
      };
      "hydra.tectonic.brianmckenna.org" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:3000";
          };
        };
      };
      "cache.tectonic.brianmckenna.org" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:5000";
          };
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
