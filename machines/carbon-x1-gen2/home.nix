{ pkgs, lib, config, ... }:

{
  imports = [
    ../../modules/home/chromium.nix
    ../../modules/home/git.nix
    ../../modules/home/kitty.nix
    ../../modules/home/password-store.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Managed by NixOS, just disable the warning
  home.file.".zshrc".text = "";

  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 128;
    x11.enable = true;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.breeze-icons;
      name = "breeze-dark";
    };
    theme = {
      package = pkgs.breeze-gtk;
      name = "Breeze-Dark";
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  programs.autojump.enable = true;
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.tmux.enable = true;
  programs.vscode.enable = true;

  services.mako.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "home.brianmckenna.org" = {
        port = 7233;
      };
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars.top = {
      icons = "awesome6";
      theme = "native";
      blocks = [
        {
          block = "focused_window";
        }
        {
          block = "net";
          device = "wlp3s0";
        }
        {
          block = "battery";
        }
        {
          block = "backlight";
        }
        {
          block = "sound";
        }
        {
          block = "time";
          format = "$timestamp.datetime(f:'%d/%m %R')";
        }
      ];
    };
  };

  wayland.windowManager = rec {
    sway = {
      enable = true;
      systemd.enable = false;
      config = {
        terminal = "kitty";
        menu = "dmenu_path | ${pkgs.wofi}/bin/wofi -d | xargs swaymsg exec --";
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
          "${sway.config.modifier}+Shift+p" = "exec passmenu";
          # "${sway.config.modifier}+Shift+p" = "exec rofi-pass";
          # "${sway.config.modifier}+Ctrl+p" = "exec ${./scripts/wofi-pass.sh}";
          # "${sway.config.modifier}+Shift+g" = "exec ${screenshot}";
        };
        bars = [
          {
            fonts = {
              names = [ "sans-serif" "Font Awesome 6 Free Solid" ];
              size = 12.0;
            };
            position = "top";
            statusCommand = "i3status-rs ${config.xdg.configHome}/i3status-rust/config-top.toml";
          }
        ];
        input = {
          "type:keyboard" = {
            repeat_delay = "250";
            repeat_rate = "50";
          };
        };
        startup = [
          {
            command = "swayidle -w timeout 120 'swaylock -f -c 000000'";
          }
          {
            command = "exec mako";
          }
        ];
      };
    };
  };

  home.packages = [
    pkgs.mg
    pkgs.brightnessctl
    pkgs.rofi-pass
    pkgs.file
    pkgs.silver-searcher
    pkgs.pv
    pkgs.swaylock
    pkgs.swayidle
    pkgs.home-manager
    pkgs.thunderbird
    pkgs.element-desktop
  ];

  home.stateVersion = "23.05";
  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
