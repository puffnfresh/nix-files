{ pkgs, ... }:

{
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/lib/nix-serve/cache-priv-key.pem";
    port = 5001;
  };

  services.postgresql.package = pkgs.postgresql_18;

  services.hydra = {
    enable = true;
    port = 3005;
    hydraURL = "https://hydra.home.brianmckenna.org";
    notificationSender = "hydra@localhost";
    # buildMachinesFiles = [];
    useSubstitutes = true;
    listenHost = "127.0.0.1";
  };
}
