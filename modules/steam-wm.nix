{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.services.xserver.windowManager.steam;
in
{
  options = {
    services.xserver.windowManager.steam = {
      enable = mkEnableOption "Steam (big picture mode) via openbox";


      args = mkOption {
        default = "-tenfoot";
        type = types.string;
        description = ''
          Arguments to provide to Steam.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [{
        name = "steam";
        start = ''
          ${pkgs.openbox}/bin/openbox-session &
          ${pkgs.steam}/bin/steam ${cfg.args} &
          waitPID=$!
        '';
      }];
    };
    environment.systemPackages = [ pkgs.steam ];
  };
}
