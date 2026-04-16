{ modulesPath, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/oci-common.nix"

    # Switches "armv8l" compatibility name to "armv7l"
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/aarch64-build-box/05298da5e1c3bed11448241134e0f1e8bcef0a1e/armv7l.nix";
      sha256 = "sha256:0xgli1krhqbdi8p2wjc8pxy7k3w551j56a7br0gd38k5765cykl9";
    })

    ./web.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.allowed-uris = [ "https://github.com/puffnfresh.keys" ];
  nix.buildMachines = [
    { hostName = "localhost";
      systems = [ "aarch64-linux" "armv7l-linux" ] ;
      supportedFeatures = [ "nixos-test" "big-parallel" "benchmark" ];
      maxJobs = 4;
      protocol = null;
    }
  ];

  services.tailscale.enable = true;
  networking.hostName = "tectonic";

  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.tectonic.brianmckenna.org";
    notificationSender = "hydra@localhost";
    # buildMachinesFiles = [];
    useSubstitutes = true;
    listenHost = "127.0.0.1";
  };

  # https://github.com/NixOS/hydra/issues/1186#issuecomment-1231513076
  systemd.services.hydra-evaluator.environment.GC_DONT_GC = "true";

  users.users.brian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "dialout" ];
    openssh.authorizedKeys.keys = [
      (builtins.readFile (builtins.fetchurl {
        url = "https://github.com/puffnfresh.keys";
        sha256 = "0gv8wpjxvb18fmvjvlg5ba9phqdhrmyl86qkkv8n7s7kq4dy12di";
      }))
    ];
  };

  system.stateVersion = "22.11";
  nixpkgs.hostPlatform = "aarch64-linux";
}
