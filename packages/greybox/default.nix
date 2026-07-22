{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  pname = "GreyBox";
  version = "1.0";

  src = ./theme;

  installPhase = ''
    mkdir -p $out/share/themes/GreyBox
    cp -r $src/* $out/share/themes/GreyBox
  '';
}
