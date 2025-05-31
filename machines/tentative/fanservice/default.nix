{ lib, stdenv, rustPlatform, fetchCrate, lm_sensors }:

rustPlatform.buildRustPackage rec {
  pname = "fanservice";
  version = "0.3.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "12aib00c5nrg0jwgppvhf06qwanld0q4w3gbgh0b9d4xsd4i7wr2";
  };
  cargoHash = "sha256-A91x7oa6cxAXJRyhvxubsWWStJIkXVe6/+mM/h397F8=";

  patches = [ ./error.patch ];

  features = [ "systemd" ];

  meta = with lib; {
    description = "Fan speed daemon for PowerEdge servers";
    homepage = "http://github.com/kazcw/fanservice";
    license = licenses.mit;
    maintainers = with maintainers; [ kazcw ];
  };

  buildInputs = [ lm_sensors ];
}
