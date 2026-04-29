{
  containers.automation = {
    config =
      { config, pkgs, ... }:
      {
        nixpkgs.config.allowUnfree = true;

        # forecast.solar doesn't respond to IPv6
        networking.enableIPv6 = false;

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
            rest = [
              {
                resource = "http://192.168.1.13/api/status";
                scan_interval = 30;
                sensor = [
                  {
                    name = "Battery SOC";
                    unique_id = "battery_emulator_soc";
                    value_template = "{{ value_json.battery[0].real_soc }}";
                    unit_of_measurement = "%";
                    device_class = "battery";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery SOH";
                    unique_id = "battery_emulator_soh";
                    value_template = "{{ value_json.battery[0].soh }}";
                    unit_of_measurement = "%";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Voltage";
                    unique_id = "battery_emulator_voltage";
                    value_template = "{{ value_json.battery[0].v }}";
                    unit_of_measurement = "V";
                    device_class = "voltage";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Current";
                    unique_id = "battery_emulator_current";
                    value_template = "{{ value_json.battery[0].i }}";
                    unit_of_measurement = "A";
                    device_class = "current";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Power";
                    unique_id = "battery_emulator_power";
                    value_template = "{{ value_json.battery[0].p }}";
                    unit_of_measurement = "W";
                    device_class = "power";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Remaining Capacity";
                    unique_id = "battery_emulator_remaining_capacity";
                    value_template = "{{ value_json.battery[0].remaining_capacity }}";
                    unit_of_measurement = "Wh";
                    device_class = "energy_storage";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Total Capacity";
                    unique_id = "battery_emulator_total_capacity";
                    value_template = "{{ value_json.battery[0].total_capacity }}";
                    unit_of_measurement = "Wh";
                    device_class = "energy_storage";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Temp Min";
                    unique_id = "battery_emulator_temp_min";
                    value_template = "{{ value_json.battery[0].temp_min }}";
                    unit_of_measurement = "°C";
                    device_class = "temperature";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Temp Max";
                    unique_id = "battery_emulator_temp_max";
                    value_template = "{{ value_json.battery[0].temp_max }}";
                    unit_of_measurement = "°C";
                    device_class = "temperature";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Cell Voltage Max";
                    unique_id = "battery_emulator_cell_mv_max";
                    value_template = "{{ value_json.battery[0].cell_mv_max }}";
                    unit_of_measurement = "mV";
                    device_class = "voltage";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Cell Voltage Min";
                    unique_id = "battery_emulator_cell_mv_min";
                    value_template = "{{ value_json.battery[0].cell_mv_min }}";
                    unit_of_measurement = "mV";
                    device_class = "voltage";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Cell Voltage Delta";
                    unique_id = "battery_emulator_cell_mv_delta";
                    value_template = "{{ value_json.battery[0].cell_mv_max - value_json.battery[0].cell_mv_min }}";
                    unit_of_measurement = "mV";
                    device_class = "voltage";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery BMS Status";
                    unique_id = "battery_emulator_bms_status";
                    value_template = "{{ value_json.bms_status }}";
                  }
                  {
                    name = "Battery Emulator RSSI";
                    unique_id = "battery_emulator_rssi";
                    value_template = "{{ value_json.rssi }}";
                    unit_of_measurement = "dBm";
                    device_class = "signal_strength";
                    state_class = "measurement";
                  }
                  {
                    name = "Battery Emulator Temp";
                    unique_id = "battery_emulator_mcu_temp";
                    value_template = "{{ value_json.temp }}";
                    unit_of_measurement = "°C";
                    device_class = "temperature";
                    state_class = "measurement";
                  }
                ];
              }
              {
                resource = "http://192.168.1.13/api/cells";
                scan_interval = 30;
                sensor = [
                  {
                    name = "Battery Cell Voltages";
                    unique_id = "battery_emulator_cell_voltages";
                    value_template = "{{ value_json.battery[0].voltages | reject('eq', 0) | list | length }}";
                    unit_of_measurement = "cells";
                    json_attributes_path = "$.battery[0]";
                    json_attributes = [ "voltages" "temp_min" "temp_max" ];
                  }
                ];
              }
            ];
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
