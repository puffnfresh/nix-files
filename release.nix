{
  kobo-clara-2e =
    (import <nixpkgs/nixos> {
      configuration = ./machines/kobo-clara-2e/configuration.nix;
      system = "armv7l-linux";
    }).config.system.build.toplevel;
}
