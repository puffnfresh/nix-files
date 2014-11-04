{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Caused a crash on boot. Sucks, cause it has Thunderbolt patches.
  # boot.kernelPackages = pkgs.linuxPackages_3_17;

  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Denver";

  fonts.enableCoreFonts = true;

  environment.systemPackages = with pkgs; [
    ack
    acpi
    autojump
    axel
    bind
    binutils
    chromium
    dmenu
    emacs
    evince
    file
    gitFull
    haskellPackages.cabal2nix
    haskellPackages.cabalInstall
    haskellPackages.ghc
    haskellPackages.hlint
    haskellPackages.pointfree
    haskellPackages.pointful
    haskellPackages.xmobar
    haskellPackages.yeganesh
    htop
    keepassx
    linuxPackages.virtualbox
    mg
    mplayer
    nix-repl
    openconnect
    powertop
    rxvt_unicode
    scrot
    silver-searcher
    terminator
    vagrant
    xdg_utils
    xlibs.xev
    xlibs.xset
  ];

  services.xserver = {
    enable = true;

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
    displayManager = {
      sessionCommands = ''
        ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
        ${pkgs.xlibs.xset}/bin/xset r rate 200 50
      '';
      lightdm.enable = true;
    };
    windowManager.default = "xmonad";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;

    # TODO: Use the mtrack driver but do better than this.
    # multitouch.enable = true;
    # multitouch.invertScroll = true;

    synaptics.additionalOptions = ''
      Option "VertScrollDelta" "-100"
      Option "HorizScrollDelta" "-100"
    '';
    synaptics.buttonsMap = [ 1 3 2 ];
    synaptics.enable = true;
    synaptics.tapButtons = false;
    synaptics.fingersMap = [ 0 0 0 ];
    synaptics.twoFingerScroll = true;
    synaptics.vertEdgeScroll = false;

    videoDrivers = [ "nouveau" ];

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };

  # Doesn't work. Maybe pommed-light is something I should package. Or
  # maybe I should just write a Haskell + DBus replacement.
  # services.hardware.pommed.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enablePepperFlash = true;
    chromium.enablePepperPDF = true;
    virtualbox.enableExtensionPack = true;

#    packageOverrides = pkgs:
#      { linux_3_17 = pkgs.linux_3_17.override {
#          extraConfig =
#            ''
#              THUNDERBOLT m
#            '';
#        };
#      };
  };

  users.mutableUsers = false;

  users.extraUsers.brian = {
    name = "brian";
    group = "users";
    uid = 1000;
    extraGroups = [ "wheel" ];
    createHome = true;
    home = "/home/brian";
    shell = "/run/current-system/sw/bin/zsh";
  };

  # Should I use this instead? Both are currently broken.
  # networking.networkmanager.enable = true;
  # networking.connman.enable = true;

  # Sadly wicd worked less than wpa_supplicant
  # networking.interfaceMonitor.enable = false;
  # networking.useDHCP = false;
  # networking.wicd.enable = true;

  networking.hostName = "bmckenna-nixos";
  networking.wireless.enable = true;
  hardware.bluetooth.enable = true;

  services.openssh.enable = true;

  services.acpid.enable = true;
  services.acpid.lidEventCommands = ''
    LID_STATE=/proc/acpi/button/lid/LID0/state
    if [ $(/run/current-system/sw/bin/awk '{print $2}' $LID_STATE) = 'closed' ]; then
      systemctl suspend
    fi
  '';

  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit =
    ''
      # Taken from <nixos/modules/programs/bash/command-not-found.nix>
      # and adapted to zsh (i.e. changed name from 'handle' to
      # 'handler').

      # This function is called whenever a command is not found.
      command_not_found_handler() {
        local p=/run/current-system/sw/bin/command-not-found
        if [ -x $p -a -f /nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite ]; then
          # Run the helper program.
          $p "$1"
          # Retry the command if we just installed it.
          if [ $? = 126 ]; then
            "$@"
          else
            return 127
          fi
        else
          echo "$1: command not found" >&2
          return 127
        fi
      }
    '';
}
