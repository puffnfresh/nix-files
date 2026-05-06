{ lib, linuxManualConfig, fetchFromGitHub, lzop, ... } @ args:

let
  passthroughArgs = builtins.removeAttrs args [ "linuxManualConfig" "fetchFromGitHub" "lzop" ];
in
(linuxManualConfig (passthroughArgs // {
  version = "7.0.0";
  modDirVersion = "7.0.0";

  src = fetchFromGitHub {
    owner = "akemnade";
    repo = "linux";
    rev = "kobo/drm-merged-7.0";
    hash = "sha256-RLZzymlB4EHEvLgj6Ef9roKZnWtkSN2ARfeHWmMnZF8=";
  };

  configfile = ./linux-clara2e.config;
  allowImportFromDerivation = true;
})).overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ lzop ];
})
