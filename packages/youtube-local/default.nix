{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "youtube-local";
  version = "2.8.13";

  src = fetchFromGitHub {
    owner = "user234683";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-xdcD5tXF5x1BQ1tJdG+uf38o+kQNGlLg55C/RS3L/dE=";
  };

  pythonEnv = pkgs.python3.withPackages (
    p: with p; [
      flask
      gevent
      brotli
      pysocks
      urllib3
      defusedxml
      cachetools
      stem
    ]
  );

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildInputs = [ pythonEnv ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/youtube-local

    cp -r * $out/share/youtube-local/

    makeWrapper ${pythonEnv}/bin/python $out/bin/youtube-local \
      --add-flags "$out/share/youtube-local/server.py"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Browser-based anonymous YouTube client.";
    homepage = "https://github.com/user234683/youtube-local";
    platforms = platforms.linux;
  };
}
