{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (!pkgs.stdenv.isDarwin && osConfig.unravelled.profiles.graphical.enable) {
    home.packages = with pkgs; [
      (nemo-with-extensions.override {
        extensions = with pkgs; [
          nemo-seahorse
          nemo-fileroller
          folder-color-switcher
          nemo-emblems 
        ];
      })
      file-roller
    ];

    xdg.mimeApps.defaultApplications = {
      "inode/directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];

      "application/zip" = [ "file-roller.desktop" ];
      "application/x-tar" = [ "file-roller.desktop" ];
      "application/x-7z-compressed" = [ "file-roller.desktop" ];
      "application/x-rar" = [ "file-roller.desktop" ];
      "application/gzip" = [ "file-roller.desktop" ];
      "application/x-bzip2" = [ "file-roller.desktop" ];
      "application/x-xz" = [ "file-roller.desktop" ];
      "application/x-compressed-tar" = [ "file-roller.desktop" ];
    };

    /*
      # needed for browsers to detect pcmanfm for some reason
      home.file.".local/share/dbus-1/services/org.freedesktop.FileManager1.service".text = ''
        [D-BUS Service]
        Name=org.freedesktop.FileManager1
        Exec="${getExe pkgs.pcmanfm} %U"
      '';
    */
  };
}
