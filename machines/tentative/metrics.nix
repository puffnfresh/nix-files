{
  containers.metrics = {
    config =
      { config, pkgs, ...}:
      {
        services.telegraf = {
          enable = true;
          extraConfig = {
            inputs = {
              cpu = { };
              ipmi_sensor.path = "/run/wrappers/bin/ipmitool";
              mem = { };

              ping = {
                method = "native";
                urls = [ "8.8.8.8" ];
              };
            };
            outputs.influxdb = { };
          };
        };
        systemd.services.telegraf.path = [ pkgs.smartmontools "/run/wrappers" ];
        services.influxdb.enable = true;
        services.grafana = {
          settings.server.http_addr = "0.0.0.0";
          enable = true;
        };
        services.unpoller = {
          enable = true;
          prometheus.disable = true;
          unifi.controllers = [ {
            url = "https://localhost:8443";
            user = "unifipoller";
            pass = "/var/lib/unpoller/password";
            verify_ssl = false;
          } ];
        };
        security.wrappers = {
          ipmitool = {
            source = "${pkgs.ipmitool}/bin/ipmitool";
            owner = "root";
            group = "root";
            setuid = true;
          };
        };
        system.stateVersion = "20.03";
     };
    allowedDevices = [
      { node = "/dev/ipmi0"; modifier = "rw"; }
    ];
    bindMounts."/dev/ipmidev/0" = { hostPath = "/dev/ipmi0"; isReadOnly = false; };

    additionalCapabilities = [ "CAP_IPC_LOCK" ];

    forwardPorts = [ { hostPort = 3000; } ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
