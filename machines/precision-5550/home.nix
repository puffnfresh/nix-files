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
  programs.mako.enable = true;

  programs.chromium = {
    enable = true;
    package = pkgs.runCommand "chromium" {
      buildInputs = [ pkgs.makeWrapper ];
    } ''
      mkdir -p $out/bin
      cp -r ${pkgs.chromium}/share $out/
      makeWrapper ${pkgs.chromium}/bin/chromium $out/bin/chromium \
        --set LIBVA_DRIVER_NAME "iHD" \
        --add-flags "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
    '';
    extensions = [
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
      { id = "cfhdojbkjhnklbpkdaibdccddilifddb"; }
      { id = "bcjindcccaagfpapjjmafapmmgkkhgoa"; }
    ];
  };

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
    matchBlocks = rec {
      atlassian = {
        hostname = "192.168.1.165";
        user = "brian";
        forwardAgent = true;
      };
      atlassian_home = atlassian // {
        proxyJump = "home";
      };
      personal = {
        hostname = "192.168.1.166";
        user = "brian";
        forwardAgent = true;
      };
      home = {
        hostname = "home.brianmckenna.org";
        user = "brian";
        forwardAgent = true;
        port = 7233;
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

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 32;
  };

  wayland.windowManager = rec {
    sway = {
      enable = true;
      systemdIntegration = false;
      xwayland = true;
      extraConfig = "include /etc/sway/config.d/*";
      config = {
        terminal = "kitty";
        modifier = "Mod4";
        focus.mouseWarping = false;
        window = {
          border = 5;
          commands = [
            {
              criteria.title = "zoom";
              command = "floating enable";
            }
          ];
        };
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
          "Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${sway.config.modifier}+d" = "exec ${pkgs.nwg-launchers}/bin/nwggrid";
        };
        bars = [
          {
            fonts = {
              names = [ "sans-serif" ];
              size = 12.0;
            };
            position = "top";
            statusCommand = "i3status-rs ${config.xdg.configHome}/i3status-rust/config-tepid.toml";
          }
        ];
        output = {
          # "eDP-1" = {
          #   scale = "3";
          #   pos = "0 600";
          # };
          # "DP-4" = {
          #   transform = "270";
          #   pos = "1280 0";
          # };
          # "DP-5" = {
          #   transform = "90";
          # };
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

    pkgs.btop
    pkgs.dtrx
    pkgs.file
    pkgs.silver-searcher
    pkgs.slack
    pkgs.spotify
    pkgs.mg
    pkgs.wofi
    pkgs.killall
    pkgs.element-desktop
    pkgs.pavucontrol
    pkgs.thunderbird
    pkgs.wdisplays
    pkgs.xdg-utils

    pkgs.zoom-us

    (pkgs.callPackage ./openconnect-atlassian { })

    (pkgs.scream.override { pulseSupport = true; })

    pkgs.looking-glass-client
  ];

  home.username = "bmckenna";
  home.homeDirectory = "/home/bmckenna";
  home.stateVersion = "22.05";
}
