{
  containers.automation = {
    config =
      { config, pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;

        services.home-assistant = {
          enable = true;
          extraComponents = [
            "default_config"
            "met"
            "goodwe"
            "jellyfin"
            "samsungtv"
            "lg_thinq"
            "lifx"
            "mobile_app"
            "ring"
            "roborock"
            "brother"
            "unifi"
            "forecast_solar"
          ];
          customComponents = [
            pkgs.home-assistant-custom-components.yoto_ha
          ];
          config = {
            homeassistant = {
              name = "Seafield";
              unit_system = "metric";
              time_zone = "Australia/Hobart";
            };
            default_config = {};
          };
        };

        services.open-webui = {
          enable = true;
          port = 19931;
          environment = {
            OLLAMA_API_BASE_URL = "http://192.168.1.204:11434";
            VECTOR_DB = "qdrant";
            QDRANT_URI = "http://127.0.0.1:6333";
          };
        };
        services.qdrant.enable = true;


        system.stateVersion = "25.05";
      };
    forwardPorts = [
      { hostPort = 19931; }
      { hostPort = 8123; }
    ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [
    19931
    8123
  ];
}
