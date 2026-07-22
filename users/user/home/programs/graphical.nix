{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf optionals;
in
{
  config = mkIf osConfig.unravelled.profiles.graphical.enable {
    home.packages =
      with pkgs;
      [
        libnotify
        grim 
        wl-clipboard
        mission-center
        loupe
      ]
      ++ optionals osConfig.unravelled.profiles.full.enable [
        libreoffice-fresh
        gnome-font-viewer 
        kdePackages.kgpg 
        seahorse
        hyprpicker
        parsec-bin
        remmina
        balsa
        signal-desktop
        obs-studio
      ];

    programs = {
      # obsidian.enable = osConfig.unravelled.profiles.full.enable;
      cava.enable = osConfig.unravelled.profiles.full.enable;
    }; 
  };
}
