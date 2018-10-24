{
  networking.firewall.allowedTCPPorts = [ 8080 ];

  services.xserver.enable = true;
  services.xserver.desktopManager.kodi.enable = true;
  services.xserver.displayManager.lightdm.autoLogin = {
    enable = true;
    user = "brian";
  };
}
