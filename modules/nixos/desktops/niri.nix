{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.unravelled.apps.desktops.niri.enable {
    programs.niri = {
      enable = mkIf config.unravelled.profiles.graphical.enable true;
    };
  };
}
