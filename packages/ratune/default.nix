{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  dbus,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ratune";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "acmagn";
    repo = "ratune";
    tag = "v${version}";
    hash = "sha256-bavGTCOoVcI4LTnnPOalu19YN+5qIYVcKkVjPAIsuzM=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
    dbus
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = {
    description = "A terminal music player for Subsonic-compatible servers";
    homepage = "https://github.com/acmagn/ratune";
    license = lib.licenses.mit;
    mainProgram = "ratune";
    platforms = lib.platforms.unix;
  };
}
