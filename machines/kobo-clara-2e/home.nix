{ config, pkgs, lib, ... }:

{
  manual.manpages.enable = false;

  home.sessionVariables.EDITOR = "mg";
  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 128;
    x11.enable = true;
  };

  xsession.enable = true;
  xsession.windowManager.awesome.enable = true;

  programs.git = {
    enable = true;
    userName = "Brian McKenna";
    userEmail = "brian@brianmckenna.org";
  };

  fonts.fontconfig.enable = true;

  programs.urxvt = {
    enable = true;
    fonts = [ "xft:Fira Mono:style=light:size=8" ];
    extraConfig = builtins.listToAttrs (map (x: {
      name = "color" + builtins.toString x;
      value = let s = lib.toHexString x; in "#${s}${s}${s}${s}${s}${s}";
    }) (builtins.genList (x: x) 16)) // {
      cursorBlink = false;
      cursorUnderline = true;
    };
  };

  home.packages = [
    pkgs.fira-mono
    pkgs.mg
    pkgs.brightnessctl
  ];

  xresources.properties = {
    "Xft.dpi" = 300;
  };

  home.username = "brian";
  home.homeDirectory = "/home/brian";
  home.stateVersion = "22.05";
}
