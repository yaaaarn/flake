{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.unravelled.options.desktops.niri.enable {
    programs.niri = {
      enable = mkIf config.unravelled.profiles.graphical.enable true;
      package = pkgs.niri;
    };
  };
}
