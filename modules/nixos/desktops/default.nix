{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [
    ./labwc.nix
    ./niri.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = mkIf config.unravelled.profiles.graphical.enable "1";
}
