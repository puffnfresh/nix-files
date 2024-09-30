{
  containers.media = {
    config =
      { config, pkgs, lib, ... }:
      {
        nixpkgs.config.allowUnfree = true;

        services.commafeed = {
          enable = true;
          environment.CF_APP_PUBLICURL = "https://reader.home.brianmckenna.org";
        };

        services.sonarr.enable = true;
        services.radarr.enable = true;
        services.prowlarr.enable = true;
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
        # https://github.com/NixOS/nixpkgs/issues/258793
        # The merged "fix" doesn't seem to work
        systemd.services.transmission.serviceConfig.BindPaths = lib.mkForce [
          "${config.services.transmission.home}/.config/transmission-daemon"
          config.services.transmission.settings.download-dir
        ];
        services.plex.enable = true;
        services.jellyfin.enable = true;
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

      { hostPort = 8082; } # commafeed

      # Jellyfin
      { hostPort = 8096; }
      { hostPort = 8920; }
      { hostPort = 1900; protocol = "udp"; }
      { hostPort = 7359; protocol = "udp"; }
    ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 7878 9091 32400 8989 8686 32469 9696 5000 8096 8920 8082 ];
  networking.firewall.allowedUDPPorts = [ 1900 7359 ];
}
