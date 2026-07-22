{
  stdenv,
  fetchFromGitHub,
  lib
}:
stdenv.mkDerivation {
  pname = "new-heterodox-mono";
  version = "0-unstable-2024-01-12";

  src = fetchFromGitHub {
    owner = "hckiang";
    repo = "font-new-heterodox-mono";
    rev = "da3284da7bb21efcd7e8eaa215aa10d9d5e65d76";
    hash = "sha256-uU/qnMFg8z/PadSIc1GZ+hWU1PUBa/XifzI2Vz5fCtA=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype/new-heterodox-mono *.otf

    runHook postInstall
  '';

  meta = {
    description = "New Heterodox Mono is an open-source serif programming font";
    homepage = "https://github.com/hckiang/font-new-heterodox-mono";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
