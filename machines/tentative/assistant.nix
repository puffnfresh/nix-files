{ nix-openclaw, ... }:

{
  containers.assistant = {
    config =
      { config, pkgs, ... }:
      {
        imports = [ nix-openclaw.nixosModules.openclaw-gateway ];

        nixpkgs.overlays = [ nix-openclaw.overlays.default ];

        services.openclaw-gateway = {
          enable = true;
          config = {
            gateway = {
              # Bind the container's veth so forwardPorts can reach it.
              bind = "lan";
            };
          };
          # ANTHROPIC_API_KEY, OPENCLAW_GATEWAY_TOKEN, channel bot tokens
          environmentFiles = [ "/var/lib/openclaw/tentative.env" ];
        };

        networking.firewall.allowedTCPPorts = [ 18789 ];
        networking = {
          nameservers = [ "208.67.220.220" "8.8.4.4" ];
          useHostResolvConf = false;
        };
        system.stateVersion = "25.05";
      };
    privateNetwork = true;
    hostAddress = "192.168.102.10";
    localAddress = "192.168.102.11";
    forwardPorts = [
      { hostPort = 18789; }
    ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 18789 ];
}
