{  lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.unravelled.options.desktops.labwc.enable {
    programs.labwc.enable = mkIf config.unravelled.profiles.graphical.enable true;
  }; 
}
