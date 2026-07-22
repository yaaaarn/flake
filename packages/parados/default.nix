{
  stdenv,
  fetchFromGitHub,
  glib,
  pkg-config,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "parados";
  version = "2.26";

  src = fetchFromGitHub {
    owner = "uint23";
    repo = "parados";
    rev = "r${version}";
    hash = "sha256-QK7DVGFJBQhzUmjlei+QLeYfnb90H+QaKpnz8nfOoP4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib ];

  makeFlags = [
    "PREFIX=$(out)"
    "MANDIR=$(out)/share/man"
    "ETCDIR=$(out)/etc"
    "GIT_VER=${version}"
  ];

  meta = {
    description = "Browser-based anonymous YouTube client.";
    homepage = "https://github.com/user234683/youtube-local";
    platforms = lib.platforms.unix;
  };
}
