{ stdenv, fetchFromGitHub }:
    
stdenv.mkDerivation {
  name = "pinentry-wsl-ps1.sh";
  src = fetchFromGitHub {
    owner = "diablodale";
    repo = "pinentry-wsl-ps1";
    rev = "4fc6ea16270c9c2f2d9daeae1ba4aa0d868d1b2a";
    sha256 = "02vlkrzprarf3xgnxcfjaxw1brqlfcz65zap2lhyhf2q0ldvf0lw";
  };
  installPhase = ''
    cp pinentry-wsl-ps1.sh $out
    chmod +x $out
    patchShebangs $out
  '';
}
