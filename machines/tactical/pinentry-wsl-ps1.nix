{ stdenv, fetchFromGitHub, makeWrapper }:

stdenv.mkDerivation {
  name = "pinentry-wsl-ps1";
  src = fetchFromGitHub {
    owner = "diablodale";
    repo = "pinentry-wsl-ps1";
    rev = "4fc6ea16270c9c2f2d9daeae1ba4aa0d868d1b2a";
    sha256 = "02vlkrzprarf3xgnxcfjaxw1brqlfcz65zap2lhyhf2q0ldvf0lw";
  };
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    chmod +x pinentry-wsl-ps1.sh
    patchShebangs pinentry-wsl-ps1.sh
    mv pinentry-wsl-ps1.sh $out/bin/
    wrapProgram $out/bin/pinentry-wsl-ps1.sh \
      --prefix PATH : /mnt/c/Windows/System32/WindowsPowerShell/v1.0
  '';
}
