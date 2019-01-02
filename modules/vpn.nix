{ lib, config, ... }:

{
  options.puffnfresh.vpn.ip = lib.mkOption {
    type = lib.types.str;
  };

  config.networking.wireguard.interfaces.wg0 = {
    ips = [ "${config.puffnfresh.vpn.ip}/29" ];
    privateKeyFile = "/var/lib/wg/private.key";
    allowedIPsAsRoutes = false;
    peers = [
      {
        publicKey = "tclKE8d7gl5zEBRdkQ2ZAR08WgjtISN5doUOaHadKW4=";
        allowedIPs = [ "10.100.0.0/29" ];
        endpoint = "tenuous.brianmckenna.org:51820";
        persistentKeepalive = 25;
      }
    ];
  };
}
