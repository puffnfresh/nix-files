{
  containers.chat = {
    config =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 8008 ];
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
          };
          enable = true;
        };
        services.postgresql = {
          enable = true;
          package = pkgs.postgresql_11;
          initialScript = pkgs.writeText "synapse-init.sql" ''
            CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
            CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
              TEMPLATE template0
              LC_COLLATE = "C"
              LC_CTYPE = "C";
          '';
        };
        networking.nameservers = [ "192.168.100.10" ];
        system.stateVersion = "20.03";
      };
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    forwardPorts = [
      { hostPort = 8008; }
    ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 8008 ];
}
