{ dockerTools, symlinkJoin, name, systemConfig }:

# with import <nixpkgs> { };
# callPackage <nixos-docker> {
#   name = "example";
#   systemConfig = {
#     environment.systemPackages = [ gitFull ];
#   };
# }

let
  minimalDocker =
    {
      imports = [ <nixpkgs/nixos/modules/profiles/minimal.nix> ];
      boot.isContainer = true;
      environment.etc.machine-id.text = "00000000000000000000000000000000";
    };
  eval =
    import <nixos/lib/eval-config.nix> {
      modules = [
        minimalDocker
        systemConfig
      ];
    };
  system =
    eval.config.system;
  image =
    dockerTools.buildImage {
      inherit name;
      contents = symlinkJoin {
        name = "${name}-contents";
        paths = [
          system.build.etc
          system.path
        ];
      };
    };
in
image
