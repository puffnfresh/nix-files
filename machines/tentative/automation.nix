{
  containers.automation = {
    config =
      { config, pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;
        services.ollama.enable = true;
        services.n8n = {
          enable = true;
          openFirewall = true;
        };
        systemd.services.n8n.environment.N8N_SECURE_COOKIE = "false";
        system.stateVersion = "25.05";
      };
    forwardPorts = [
      { hostPort = 5678; }
    ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 5678 ];
}
