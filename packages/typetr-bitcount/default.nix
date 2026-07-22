{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation {
  pname = "typetr-bitcount";
  version = "0-unstable-2025-09-05";

  src = fetchFromGitHub {
    owner = "petrvanblokland";
    repo = "TYPETR-Bitcount";
    rev = "89e7994f73b7f5ced80e7cf493d40be9e66ff82f";
    hash = "sha256-WENI7UDpxfG8g8akJyyEtWu3Rs4nuNX7nghchAuS75I=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype/typetr-bitcount fonts/ttf/variable/*.ttf

    runHook postInstall
  '';

  meta = {
    description = "A massive programmatic pixel-font system with modular shapes and layering variations";
    homepage = "https://github.com/petrvanblokland/TYPETR-Bitcount";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
