{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "extest";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Supreeeme";
    repo = "extest";
    rev = version;
    hash = "sha256-N2QCTBZ2tDTq+rD40AcrLH3CG4fPBf7uiCKE25ob0Fc=";
  };

  cargoHash = "sha256-MSC0xZ1CnyFhiz8ETOGkbLzMDSMcgs5GeC8Igt0vvr0=";

  meta = with lib; {
    description = "X11 XTEST reimplementation primarily for Steam Controller on Wayland";
    homepage = "https://github.com/Supreeeme/extest";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.puffnfresh ];
  };
}
