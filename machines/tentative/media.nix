{
  containers.media = {
    config =
      { config, pkgs, lib, ... }:
      {
        nixpkgs.config.allowUnfree = true;
        services.lidarr.enable = true;
        services.sonarr.enable = true;
        services.radarr.enable = true;
        # services.readarr.enable = true;
        services.prowlarr.enable = true;
        services.kavita = {
          tokenKeyFile = "/var/lib/kavita/token.key";
          enable = true;
        };
        services.transmission = {
          enable = true;
          downloadDirPermissions = "0777";
          settings = {
            download-dir = "/media/Downloads";
            rpc-whitelist = "127.0.0.1,192.168.1.*";
            rpc-bind-address = "0.0.0.0";
            ratio-limit-enabled = true;
          };
        };
        systemd.services.transmission.serviceConfig.BindReadOnlyPaths = lib.mkForce [ builtins.storeDir "/etc" ];
        services.plex.enable = true;
        system.stateVersion = "20.03";
      };
    forwardPorts = [
      { hostPort = 5000; }
      { hostPort = 7878; }
      { hostPort = 9091; }
      { hostPort = 32400; }
      # { hostPort = 8787; }
      { hostPort = 8989; }
      { hostPort = 8686; }
      { hostPort = 9696; }
      { hostPort = 32469; }
      { hostPort = 1900; protocol = "udp"; }
    ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 7878 9091 32400 8989 8686 32469 9696 5000 ];
  networking.firewall.allowedUDPPorts = [ 1900 ];
}
