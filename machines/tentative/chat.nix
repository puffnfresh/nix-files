{
  containers.chat = {
    config =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 8008 8009 ];
        services.matrix-synapse = {
          settings = {
            server_name = "chat.home.brianmckenna.org";
            listeners = [
              {
                port = 8008;
                tls = false;
                bind_addresses = [ "0.0.0.0" ];
                resources = [
                  { names = ["client"]; compress = true; }
                  { names = ["federation"]; compress = false; }
                ];
              }
            ];
            database_type = "psycopg2";
            no_tls = true;

            retention = {
              enabled = true;
              default_policy.max_lifetime = "180d";
              purge_jobs = [
                { interval = "1d"; }
              ];
            };
          };
          enable = true;
        };
        services.postgresql = {
          enable = true;
          initialScript = pkgs.writeText "synapse-init.sql" ''
            CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
            CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
              TEMPLATE template0
              LC_COLLATE = "C"
              LC_CTYPE = "C";
          '';
        };
        networking = {
          # resolvconf.enable = true;
          nameservers = [ "208.67.220.220" "8.8.4.4" ];
          useHostResolvConf = false;
        };
        system.stateVersion = "23.11";
      };
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    forwardPorts = [
      { hostPort = 8008; }
      { hostPort = 8009; }
    ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 8008 ];
}
