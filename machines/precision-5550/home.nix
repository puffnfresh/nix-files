{ pkgs, config, lib, ... }:

let
  secrets = import ./secrets.nix;
in
{
  programs.autojump.enable = true;
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.tmux.enable = true;
  programs.vscode.enable = true;
  programs.firefox.enable = true;
  programs.mako.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      term = "xterm-256color";
      close_on_child_death = "yes";
    };
  };

  programs.ssh = {
    enable = true;
    serverAliveInterval = 120;
    matchBlocks = {
      atlassian = {
        hostname = "192.168.1.165";
        user = "brian";
        forwardAgent = true;
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Brian McKenna";
    userEmail = "bmckenna@atlassian.com";
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass-wayland;
  };

  programs.i3status-rust = {
    enable = true;
    bars.tepid = {
      icons = "awesome5";
      theme = "native";
      blocks = [
        {
          block = "focused_window";
        }
        {
          block = "net";
          device = "enp59s0u2u4";
        }
        {
          block = "weather";
          service = {
            name = "openweathermap";
            inherit (secrets.openweathermap) api_key;
            city_id = "2155416";
            units = "metric";
          };
        }
        {
          block = "sound";
        }
        {
          block = "time";
          format = "%d/%m %R";
        }
      ];
    };
  };

  wayland.windowManager = rec {
    sway = {
      enable = true;
      systemdIntegration = false;
      config = {
        terminal = "kitty";
        modifier = "Mod4";
        focus.mouseWarping = false;
        window.border = 5;
        startup = [
          {
            command = "exec mako";
          }
        ];
        colors.focused = {
          border = "#FF0000";
          background = "#285577";
          text = "#ffffff";
          indicator = "#2e9ef4";
          childBorder = "#FF0000";
        };
        keybindings = lib.mkOptionDefault {
          "${sway.config.modifier}+Ctrl+p" = "exec ${./scripts/wofi-pass.sh}";
          "${sway.config.modifier}+Shift+g" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
        };
        bars = [
          {
            fonts = [ "sans-serif 10" ];
            position = "top";
            statusCommand = "i3status-rs ${config.xdg.configHome}/i3status-rust/config-tepid.toml";
          }
        ];
        output = {
          "eDP-1" = {
            scale = "3";
            pos = "0 600";
          };
          "DP-4" = {
            transform = "270";
            pos = "1280 0";
          };
          "DP-5" = {
            transform = "90";
          };
        };
        input = {
          "type:keyboard" = {
            repeat_delay = "250";
            repeat_rate = "50";
            xkb_options = "ctrl:nocaps";
          };
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  news.display = "silent";

  home.packages = [
    pkgs.home-manager

    pkgs.file
    pkgs.silver-searcher
    pkgs.slack
    pkgs.spotify
    pkgs.wofi
    pkgs.killall

    (pkgs.callPackage ./openconnect-atlassian { })

    (pkgs.scream-receivers.override { pulseSupport = true; })

    pkgs.looking-glass-client
  ];
}
