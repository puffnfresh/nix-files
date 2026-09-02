{
  services.openthread-border-router = {
    enable = true;
    radio = {
      device = "/dev/serial/by-id/usb-Nabu_Casa_Home_Assistant_Connect_ZBT-1_00901e0c42cff011bca085c5e9520995-if00-port0";
      baudRate = 460800;
      flowControl = true;
    };
    backboneInterfaces = [ "br0" ];
    rest.listenAddress = "127.0.0.1";
  };

  services.matter-server.enable = true;

  networking.firewall.allowedUDPPorts = [ 5353 ];
}
