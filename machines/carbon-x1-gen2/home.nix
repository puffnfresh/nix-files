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

  # programs.zsh = {
  #   enable = true;
  #   enableSyntaxHighlighting = true;
  #   oh-my-zsh = {
  #     enable = true;
  #     theme = "kennethreitz";
  #   };
  # };

  programs.autojump.enable = true;
  programs.htop.enable = true;
  programs.jq.enable = true;
  programs.tmux.enable = true;
  programs.vscode.enable = true;

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
      icons = "awesome5";
      theme = "native";
      blocks = [
        {
          block = "focused_window";
          max_width = 50;
        }
        {
          block = "sound";
        }
        {
          block = "backlight";
        }
        {
          block = "battery";
          format = "{percentage} {time}";
        }
        {
          block = "time";
          format = "%d %b %I:%M %p";
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
            fonts = [ "sans-serif 10" ];
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
            command = "swayidle -w timeout 60 'swaylock -f -c 000000'";
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
    pkgs.mako
    pkgs.home-manager
    pkgs.thunderbird
    pkgs.element-desktop
  ];

  home.stateVersion = "23.05";
  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
