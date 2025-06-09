{
  containers.media = {
    config =
      { config, pkgs, lib, ... }:
      {
        nixpkgs.config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "aspnetcore-runtime-6.0.36"
            "aspnetcore-runtime-wrapped-6.0.36"
            "dotnet-sdk-6.0.428"
            "dotnet-sdk-wrapped-6.0.428"
          ];
        };

        services.commafeed = {
          enable = true;
          environment.CF_APP_PUBLICURL = "https://reader.home.brianmckenna.org";
        };
        services.karakeep = {
          enable = true;
          extraEnvironment = {
            PORT = "3001";
            NEXTAUTH_URL = "https://notes.home.brianmckenna.org";
            OLLAMA_BASE_URL = "http://192.168.1.204:11434";
            INFERENCE_TEXT_MODEL = "llama3.1:8b";
            INFERENCE_IMAGE_MODEL = "llama3.1:8b";
            EMBEDDING_TEXT_MODEL = "nomic-embed-text";
            DISABLE_SIGNUPS = "true";
            DISABLE_NEW_RELEASE_CHECK = "true";
          };
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
            no-incomplete-dir = true;
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
        networking.firewall.allowedTCPPorts = [ 8082 9091 3001 ];

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
      # { hostPort = 1900; protocol = "udp"; } # plex DLNA
      { hostPort = 8082; } # commafeed
      { hostPort = 2283; } # immich
      { hostPort = 3001; } # karakeep

      # Jellyfin
      { hostPort = 8096; }
      { hostPort = 8920; }
      # { hostPort = 1900; protocol = "udp"; }
      { hostPort = 7359; protocol = "udp"; }
    ];
    autoStart = true;
  };

}
