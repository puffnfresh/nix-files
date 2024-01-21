{ pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "nwg-drawer";

      "$rosewater" = "0xfff5e0dc";
      "$red" = "0xfff38ba8";
      "$surface1" = "0xff45475a";
      "$surface0" = "0xff313244";

      monitor = [
        "desc:Samsung Display Corp. 0x4165,preferred,0x0,2.5"
        "desc:Dell Inc. DELL U2414H H8H7G57B3JJS,1920x1080,1536x-400,1,transform,1"
        "desc:Dell Inc. DELL U2414H H8H7G57B3JHS,preferred,2616x0,1"
      ];
      dwindle = {
        preserve_split = true;
      };
      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, Space, togglefloating,"
        "$mainMod, D, exec, $menu"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, R, togglesplit, # dwindle"
        "$mainMod CTRL, P, exec, ${./scripts/wofi-pass.sh}"
        "$mainMod SHIFT, G, exec, ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area"

        "$mainMod, F, fullscreen"
        "$mainMod, E, togglegroup"

        "$mainMod, H, movefocus, l"
        "$mainMod, J, movefocus, d"
        "$mainMod, K, movefocus, u"
        "$mainMod, L, movefocus, r"

        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, J, movewindow, d"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, L, movewindow, r"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      misc = {
        force_default_wallpaper = 0;
      };
      decoration = {
        inactive_opacity = 0.9;
        rounding = 5;
        dim_inactive = true;
        dim_strength = 0.2;
      };
      animations = {
        enabled = false;
        # enabled = true;
        bezier = "easeInOutQuad, 0.45, 0, 0.55, 1";

        animation = [
          "windows, 1, 1, easeInOutQuad, slide"
          # "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          # "borderangle, 1, 8, default"
          # "fade, 1, 7, default"
          # "workspaces, 1, 6, default"
          "workspaces, 1, 1, easeInOutQuad, slide"
        ];
      };
      input = {
        repeat_delay = 250;
      };
      general = {
        "col.active_border" = "$red";
        "col.inactive_border" = "$surface1 $surface0 45deg";
        border_size = 5;
        gaps_out = 5;
      };
      # opengl.nvidia_anti_flicker = 0;
    };
    # systemd.enable = false;
  };

  xdg.configFile."hypr/hyprpaper.conf".text =
    let
      settings = {
        preload = [ "${./catppuccin_mocha_base_white_atlassian.png}" ];
        wallpaper = [ ",${./catppuccin_mocha_base_white_atlassian.png}" ];
        splash = true;
      };
    in
      lib.generators.toKeyValue {
        listsAsDuplicateKeys = true;
      } settings;

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
          "hyprland/submap"
        ];
        modules-right = [
          "wireplumber"
          "network"
          "cpu"
          "memory"
          "temperature"
          # "backlight"
          # "battery"
          "clock"
          "tray"
        ];
        clock = {
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          # on-click = "${pkgs.xdg-utils}/bin/xdg-open https://calendar.google.com/";
        };
        "hyprland/workspaces" = {
          on-scroll-up = "${pkgs.hyprland}/bin/hyprctl dispatch workspace m-1";
          on-scroll-down = "${pkgs.hyprland}/bin/hyprctl dispatch workspace m+1";
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{}% 󰍛";
        };
        temperature = {
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
        network = {
          format-ethernet = "{ipaddr}/{cidr} 󰈀";
        };
        wireplumber = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = ["" "" ""];
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
          scroll-step	= 5;
        };
      };
    };
    style = ''
      @import "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Alexays/Waybar/6e12f8122347ae279ae0fa1923acd6b908fa769c/resources/style.css";
        sha256 = "sha256-m+nlK8m6kC1O7wpgwBidSn2tZeEli50NbtaNGXLkem0=";
      }}";
      @import "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/waybar/f74ab1eecf2dcaf22569b396eed53b2b2fbe8aff/themes/mocha.css";
        sha256 = "sha256-viMWDeNWNfSE3TcBoTghzSYqi0IKxMQQk3qfSB2HeJU=";
      }}";

      window#waybar {
        background-color: @yellow;
        color: @base;
        border-bottom: none;
      }

      #tray {
        background-image: linear-gradient(90deg, @flamingo, @rosewater);
      }

      #clock {
        background-image: linear-gradient(90deg, @pink, @flamingo);
        color: @base;
      }

      #temperature {
        background-image: linear-gradient(90deg, @mauve, @pink);
        color: @base;
      }

      #memory {
        background-image: linear-gradient(90deg, @red, @mauve);
        color: @base;
      }

      #cpu {
        background-image: linear-gradient(90deg, @maroon, @red);
      }

      #network {
        background-image: linear-gradient(90deg, @peach, @maroon);
        color: @base;
      }

      #wireplumber {
        background-image: linear-gradient(90deg, @yellow, @peach);
      }

      #wireplumber.muted {
        background-color: @lavender;
      }

      #workspaces {
        background-image: linear-gradient(90deg, @green, @yellow);
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
      }

      #workspaces button {
        /* background-color: @green; */
        color: @base;
      }

      #workspaces button.active {
        background-color: alpha(@teal, 0.5);
      }

      #workspaces button.urgent {
        background-color: alpha(@red, 0.5);
      }

      #workspaces button:hover {
        background-color: alpha(@teal, 0.8);
      }
    '';
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
      };
    };
  };

  services.mako = {
    enable = true;
    # backgroundColor = "#1e1e2e";
    # textColor = "#cdd6f4";
    # borderColor = "#89b4fa";
    # progressColor = "over #313244";
    extraConfig = builtins.readFile (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/mako/9dd088aa5f4529a3dd4d9760415e340664cb86df/src/mocha";
      sha256 = "sha256-wGcrA8btL4KW0p9Lz1R4CJ8QDYznXLOOmYsNOkBoS/E=";
    });
  };

  programs.wofi = {
    enable = true;
    style = ''
      @import "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/xlce/wofi/cdaa582a1d8e9e8fcbd6e159ee337a72b0059a61/src/mocha/blue/style.css";
        sha256 = "sha256-8at+u9R4YtKaD4UHPT1ilKXiCi7QyyPe0r6PeumpfNg=";
      }}";
    '';
  };

  home.packages = [
    pkgs.nwg-drawer
    pkgs.nerdfonts
  ];
}
