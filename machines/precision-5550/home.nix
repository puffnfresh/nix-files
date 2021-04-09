{ pkgs, config, lib, ... }:

let
  screenshot = pkgs.writeShellScript "screenshot.sh" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
  secrets = import ./secrets.nix;
in
{
  programs.autojump.enable = true;
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.tmux.enable = true;
  programs.vscode.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
    ];
  };

  programs.kitty = {
    enable = true;
    settings.term = "xterm-256color";
  };

  programs.ssh = {
    enable = true;
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
    userEmail = "brian@brianmckenna.org";
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
          device = "eth0";
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
        colors.focused = {
          border = "#FF0000";
          background = "#285577";
          text = "#ffffff";
          indicator = "#2e9ef4";
          childBorder = "#FF0000";
        };
        keybindings = lib.mkOptionDefault {
          "${sway.config.modifier}+Ctrl+p" = "exec ${./scripts/wofi-pass.sh}";
          "${sway.config.modifier}+Shift+g" = "exec ${screenshot}";
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
          "DP-3" = {
            transform = "270";
            pos = "1280 0";
          };
          "DP-1" = {
            transform = "90";
          };
        };
        input = {
          "type:keyboard" = {
            repeat_delay = "250";
            repeat_rate = "50";
          };
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  news.display = "silent";

  home.packages = [
    pkgs.home-manager

    pkgs.silver-searcher
    pkgs.slack
    pkgs.spotify
    pkgs.wofi

    (pkgs.callPackage ./openconnect-atlassian { })

    (pkgs.scream-receivers.override { pulseSupport = true; })

    (pkgs.looking-glass-client.overrideAttrs (attrs: {
      version = "ae36abb";

      src = pkgs.fetchFromGitHub {
        owner = "gnif";
        repo = "LookingGlass";
        rev = "ae36abb1ca3a645ac816667d6290121ac641cb01";
        sha256 = "1cgcnvs7kbqcn3sczl09js58q7y9lmq4w61wh2zq3s8p30144f9s";
        fetchSubmodules = true;
      };

      buildInputs = attrs.buildInputs ++ [
        pkgs.wayland-protocols
        pkgs.xorg.libXScrnSaver
        pkgs.xorg.libXinerama
        pkgs.xorg.libXi
      ];

      NIX_CFLAGS_COMPILE = "-mavx";
    }))
  ];
}
