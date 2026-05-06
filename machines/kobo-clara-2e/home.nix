{ config, pkgs, lib, ... }:

{
  manual.manpages.enable = false;

  home.sessionVariables.EDITOR = "mg";

  programs.git = {
    enable = true;
    settings.user = {
      name = "Brian McKenna";
      email = "brian@brianmckenna.org";
    };
  };

  home.packages = [
    pkgs.mg
    pkgs.brightnessctl
  ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";
  home.stateVersion = "22.05";
}
