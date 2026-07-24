{
  lib,
  pkgs,
  osConfig,
  inputs,
  self,
  ...
}:
let
  inherit (lib) mkIf mkDefault;
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

  config = mkIf (pkgs.stdenv.isLinux && osConfig.unravelled.profiles.graphical.enable) {
    services.wbg = {
      enable = true;
      stretch = mkDefault true;
      image = mkDefault "${self}/wallpapers/monst3r-11153458.jpg";
    };
  };
}
