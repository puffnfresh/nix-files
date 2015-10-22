{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "mate-common";
  version = "1.10.0";
  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-common";
    rev = "${name}-${version}";
    sha256 = "0qdrsq7rlh8c5p8kjjiy4i3wxhbp4rd95pr7qkg5479rbaixl266";
  };
  buildInputs = [ autoreconfHook ];
}
