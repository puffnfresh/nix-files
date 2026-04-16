{
  containers.metrics = {
    config =
      { config, pkgs, ... }:
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

              http = [
                {
                  urls = [ "http://192.168.1.13/api/cells" ];
                  method = "GET";
                  interval = "10s";
                  timeout = "5s";
                  name_override = "battery";
                  data_format = "json";
                  json_query = "battery.0";
                }
                {
                  urls = [ "http://192.168.1.13/api/status" ];
                  method = "GET";
                  interval = "10s";
                  timeout = "5s";
                  name_override = "battery_status";
                  data_format = "json";
                  json_query = "battery.0";
                }
              ];
            };
            outputs.influxdb = { };
            processors.starlark = [
              {
                source = ''
                  def apply(metric):
                      # Only touch battery metrics
                      if metric.name != "battery":
                          return metric

                      out = []

                      for field, value in metric.fields.items():
                          if not field.startswith("voltages_"):
                              continue

                          if value == 0:
                              continue

                          cell = field.split("_")[1]

                          m = Metric(
                              "battery_cell",
                              {
                                  "host": metric.tags.get("host", ""),
                                  "cell": cell,
                              },
                              {
                                  "voltage": value,
                              },
                          )

                          # Preserve original timestamp
                          m.time = metric.time

                          # Optional temperature fields
                          if "temp_min" in metric.fields:
                              m.fields["temp_min"] = metric.fields["temp_min"]
                          if "temp_max" in metric.fields:
                              m.fields["temp_max"] = metric.fields["temp_max"]

                          out.append(m)

                      # Returning a list drops the original "battery" metric
                      return out
                '';
              }
            ];
          };
        };
        systemd.services.telegraf.path = [
          pkgs.smartmontools
          "/run/wrappers"
        ];
        services.influxdb.enable = true;
        services.grafana = {
          settings.server.http_addr = "0.0.0.0";
          enable = true;
        };
        services.unpoller = {
          enable = true;
          prometheus.disable = true;
          unifi.controllers = [
            {
              url = "https://localhost:8443";
              user = "unifipoller";
              pass = "/var/lib/unpoller/password";
              verify_ssl = false;
            }
          ];
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
      {
        node = "/dev/ipmi0";
        modifier = "rw";
      }
    ];
    bindMounts."/dev/ipmidev/0" = {
      hostPath = "/dev/ipmi0";
      isReadOnly = false;
    };

    additionalCapabilities = [ "CAP_IPC_LOCK" ];

    forwardPorts = [ { hostPort = 3000; } ];
    autoStart = true;
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
