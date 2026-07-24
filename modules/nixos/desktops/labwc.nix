{  lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.unravelled.desktops.labwc.enable {
    programs.labwc.enable = mkIf config.unravelled.profiles.graphical.enable true;
  }; 
}
