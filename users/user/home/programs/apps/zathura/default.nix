{ osConfig, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf osConfig.unravelled.profiles.graphical.enable {
    programs.zathura.enable = true;

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
    };
  };
}
