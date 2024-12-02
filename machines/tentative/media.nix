{
  containers.media = {
    config =
      { config, pkgs, lib, ... }:
      {
        nixpkgs.config = {
          allowUnfree = true;
          config.permittedInsecurePackages = [
            "aspnetcore-runtime-wrapped-6.0.36"
          ];
        };

        services.commafeed = {
          enable = true;
          environment.CF_APP_PUBLICURL = "https://reader.home.brianmckenna.org";
        };

        services.immich = {
          enable = true;
          host = "0.0.0.0";
          openFirewall = true;
          mediaLocation = "/media/Photos";
        };

        services.sonarr = {
          enable = true;
          openFirewall = true;
        };
        services.radarr = {
          enable = true;
          openFirewall = true;
        };
        services.prowlarr = {
          enable = true;
          openFirewall = true;
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
        # https://github.com/NixOS/nixpkgs/issues/258793
        # The merged "fix" doesn't seem to work
        systemd.services.transmission.serviceConfig.BindPaths = lib.mkForce [
          "${config.services.transmission.home}/.config/transmission-daemon"
          config.services.transmission.settings.download-dir
        ];
        services.plex = {
          enable = true;
          openFirewall = true;
        };
        services.jellyfin = {
          enable = true;
          openFirewall = true;
        };

        networking = {
          nameservers = [ "208.67.220.220" "8.8.4.4" ];
          useHostResolvConf = false;
        };
        networking.firewall.allowedTCPPorts = [ 8082 9091 ];

        system.stateVersion = "24.05";
      };
    privateNetwork = true;
    hostAddress = "192.168.101.10";
    localAddress = "192.168.101.11";
    forwardPorts = [
      { hostPort = 7878; } # sonarr
      { hostPort = 9091; } # transmission
      { hostPort = 32400; } # plex
      { hostPort = 8989; } # radarr
      { hostPort = 9696; } # prowlarr
      { hostPort = 32469; } # plex DLNA
      { hostPort = 1900; protocol = "udp"; } # plex DLNA
      { hostPort = 8082; } # commafeed
      { hostPort = 3001; } # immich

      # Jellyfin
      { hostPort = 8096; }
      { hostPort = 8920; }
      # { hostPort = 1900; protocol = "udp"; }
      { hostPort = 7359; protocol = "udp"; }
    ];
    autoStart = true;
  };

}
