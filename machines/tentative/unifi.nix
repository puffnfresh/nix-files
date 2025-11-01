{ config
, ...
}:

{
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      unifi-controller = {
        image = "jacobalberty/unifi:latest";
        autoStart = true;
        ports = [
          "8080:8080"
          "8443:8443"
          "3478:3478/udp"
          "10001:10001/udp"
        ];
        volumes = ["/var/lib/unifi:/unifi"];
      };
    };
  };

   networking.firewall = {
    allowedTCPPorts = [
      8080 # Port for UAP to inform controller.
      8843 # Port for HTTPS portal redirect, ditto.
    ];
    allowedUDPPorts = [
      3478 # UDP port used for STUN.
      10001 # UDP port used for device discovery.
    ];
  };
}
