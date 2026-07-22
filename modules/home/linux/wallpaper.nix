{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;

  wallpaperCommand = "systemctl restart --user quickshell || true &";
in
{
  config = mkIf osConfig.unravelled.profiles.graphical.enable {
    home.activation.setWallpaper = (lib.hm.dag.entryAfter [ "writeBoundary" ] wallpaperCommand);
  };
}
