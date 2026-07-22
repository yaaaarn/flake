{
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports =
    if (pkgs.stdenv.isLinux && osConfig.unravelled.profiles.graphical.enable) then
      [
        inputs.tangle.hmModules.default
        ./shared

        ./labwc
        ./niri

        ./battery.nix
      ]
    else
      [ ];

  config = mkIf (pkgs.stdenv.isLinux && osConfig.unravelled.profiles.graphical.enable && osConfig.unravelled.profiles.laptop.enable) {
      };
}
