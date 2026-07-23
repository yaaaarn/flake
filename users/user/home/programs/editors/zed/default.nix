{ lib, osConfig, pkgs, ... }:
let
  inherit (lib) mkIf;
in
{
  home.packages = with pkgs; [
    nil
    nixd
    package-version-server
  ];

  programs.zed-editor = {
    enable = mkIf osConfig.unravelled.apps.editors.zed.enable true;

    extensions = [
      "nix"
      "html"
      "scss"
      "astro"
      "svelte"

      "poimandres"
      "colored-zed-icons-theme"
    ];

    userSettings = {
      ui_font_family = "Maple Mono NF CN";
      ui_font_size = 11;

      buffer_font_family = "Maple Mono NF CN";
      buffer_font_size = 11;

      terminal.font_family = "Maple Mono NF CN";

      theme = "poimandres";
      icon_theme = "Colored Zed Icons Theme Dark";

      hour_format = "hour24";

      minimap = {
        show = "always";
      };

      tab_size = 2;
    };
  };
}
