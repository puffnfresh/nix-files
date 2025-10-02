{
  containers.automation = {
    config =
      { config, pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;

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

        services.n8n = {
          enable = true;
          openFirewall = true;
        };
        systemd.services.n8n.environment.N8N_SECURE_COOKIE = "false";

        system.stateVersion = "25.05";
      };
    forwardPorts = [
      { hostPort = 5678; }
      { hostPort = 19931; }
    ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 5678 19931 ];
}
