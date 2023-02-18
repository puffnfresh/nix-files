{ modulesPath, ... }:

{
  imports = [
    # "${modulesPath}/virtualisation/oci-common.nix"
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixpkgs/4d109af84c42f13500d34a878da86beff9482494/nixos/modules/virtualisation/oci-options.nix";
      sha256 = "sha256:06ydpyvibqnv5q92rxn4dqfsh425yy31c2iviajjxmadgzj9rlq4";
    })
    ./oci-common.nix

    # Switches "armv8l" compatibility name to "armv7l"
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/nix-community/aarch64-build-box/69bf35573e2b3b98fe36b13708f7a86c1e8920da/armv7l.nix";
      sha256 = "sha256:0j90fs78vff22xacq6rq2hiay7ayd8wkvarbmwqn2wr9p43rjn9w";
    })

    ./web.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.substituters = [ "https://cache.armv7l.xyz" ];
  nix.settings.trusted-public-keys = [ "cache.armv7l.xyz-1:kBY/eGnBAYiqYfg0fy0inWhshUo+pGFM3Pj7kIkmlBk=" ];
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
}
