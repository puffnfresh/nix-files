{ pkgs, lib, config, ... }:

{
  catppuccin = {
    gtk = {
      enable = true;
      accent = "blue";
    };
    cursors.enable = true;
    mako.enable = true;
    waybar.enable = true;
  };

  programs.niri = {
    enable = true;
    settings = {
      outputs."Samsung Display Corp. 0x4165 Unknown" = {
        position = {
          x = 0;
          y = 720;
        };
      };
      input.focus-follows-mouse.enable = true;
      outputs."Dell Inc. DELL U2414H H8H7G57B3JJS" = {
        position = {
          x = 1920;
          y = 0;
        };
        transform.rotation = 90;
      };
      layout.focus-ring = {
        active.color = "#f38ba8";
      };
      binds = let a = config.lib.niri.actions; in {
        "Mod+Ctrl+P".action = a.spawn "${./scripts/wofi-pass.sh}";
        "Mod+Shift+Slash".action = a.show-hotkey-overlay;
        "Mod+D".action = a.spawn "nwg-drawer";
        "Mod+H".action = a.focus-column-left;
        "Mod+J".action = a.focus-window-or-workspace-down;
        "Mod+K".action = a.focus-window-or-workspace-up;
        "Mod+L".action = a.focus-column-right;
        "Mod+Return".action = a.spawn "kitty";
        "Mod+Q".action = a.close-window;
        "Mod+Ctrl+H".action = a.move-column-left;
        "Mod+Ctrl+J".action = a.move-window-down;
        "Mod+Ctrl+K".action = a.move-window-up;
        "Mod+Ctrl+L".action = a.move-column-right;
        "Mod+Shift+H".action = a.focus-monitor-left;
        "Mod+Shift+J".action = a.focus-monitor-down;
        "Mod+Shift+K".action = a.focus-monitor-up;
        "Mod+Shift+L".action = a.focus-monitor-right;
        "Mod+R".action = a.switch-preset-column-width;
        "Mod+Shift+R".action = a.switch-preset-window-height;
        "Mod+Ctrl+R".action = a.reset-window-height;
        "Mod+F".action = a.maximize-column;
        "Mod+Shift+F".action = a.fullscreen-window;
        "Mod+Shift+E".action = a.quit;
        "Mod+Shift+P".action = a.power-off-monitors;
        "Mod+1".action = a.focus-workspace 1;
        "Mod+2".action = a.focus-workspace 2;
        "Mod+3".action = a.focus-workspace 3;
        "Mod+4".action = a.focus-workspace 4;
        "Mod+5".action = a.focus-workspace 5;
        "Mod+6".action = a.focus-workspace 6;
        "Mod+7".action = a.focus-workspace 7;
        "Mod+8".action = a.focus-workspace 8;
        "Mod+9".action = a.focus-workspace 9;
        "Mod+Ctrl+1".action = a.move-column-to-workspace 1;
        "Mod+Ctrl+2".action = a.move-column-to-workspace 2;
        "Mod+Ctrl+3".action = a.move-column-to-workspace 3;
        "Mod+Ctrl+4".action = a.move-column-to-workspace 4;
        "Mod+Ctrl+5".action = a.move-column-to-workspace 5;
        "Mod+Ctrl+6".action = a.move-column-to-workspace 6;
        "Mod+Ctrl+7".action = a.move-column-to-workspace 7;
        "Mod+Ctrl+8".action = a.move-column-to-workspace 8;
        "Mod+Ctrl+9".action = a.move-column-to-workspace 9;
        "Mod+BracketLeft".action = a.consume-or-expel-window-left;
        "Mod+BracketRight".action = a.consume-or-expel-window-right;
        "Mod+Shift+S".action = a.screenshot;
        "Mod+W".action = a.toggle-column-tabbed-display;
        "Mod+V".action = a.toggle-window-floating;
        "Mod+Shift+V".action = a.switch-focus-between-floating-and-tiling;
        "Mod+Minus".action = a.set-column-width "-10%";
        "Mod+Equal".action = a.set-column-width "+10%";
        "Mod+Shift+Minus".action = a.set-window-height "-10%";
        "Mod+Shift+Equal".action = a.set-window-height "+10%";
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        modules-left = [
          # "hyprland/workspaces"
          # "hyprland/window"
          # "hyprland/submap"
          "niri/workspaces"
          "niri/window"
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
        url = "https://raw.githubusercontent.com/Alexays/Waybar/cad18f39f51fdbd93d3236572c8f18728b3a0930/resources/style.css";
        sha256 = "sha256-IUKx+izpXXgU7H6FMliStONDqovzqMArzh/KwQ2F0HA=";
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

  gtk.enable = true;

  services.mako.enable = true;

  programs.wofi = {
    enable = true;
    # style = ''
    #   @import "${pkgs.fetchurl {
    #     url = "https://raw.githubusercontent.com/xlce/wofi/cdaa582a1d8e9e8fcbd6e159ee337a72b0059a61/src/mocha/blue/style.css";
    #     sha256 = "sha256-8at+u9R4YtKaD4UHPT1ilKXiCi7QyyPe0r6PeumpfNg=";
    #   }}";
    # '';
  };

  home.packages = [
    pkgs.nwg-drawer
    pkgs.nerd-fonts.symbols-only
  ];
}
