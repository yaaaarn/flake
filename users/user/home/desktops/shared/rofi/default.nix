{ colors, config, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;

    font = "Maple Mono NF CN 9";
    modes = [ "drun" ];
    terminal = "foot";

    extraConfig = {
      show-icons = true;
      fixed-num-lines = false;
    };

    theme = {
      "*" = {
        text-color = mkLiteral "#${colors.foreground}";
        background-color = mkLiteral "transparent";
      };

      window = {
        width = mkLiteral "256px";
        padding = mkLiteral "8px";
        spacing = mkLiteral "8px";

        anchor = mkLiteral "west";
        location = mkLiteral "west";

        children = map mkLiteral [ "horibox" "listview" ];

        background-color = mkLiteral "#${colors.background}";
        border-radius = mkLiteral "12px";
      };

      horibox = {
        expand = false;
        orientation = mkLiteral "horizontal";
        children = map mkLiteral [ "prompt" "entry" ];
      };

      listview = {
        layout = mkLiteral "vertical";
        spacing = mkLiteral "4px";
      };

      entry = {
        width = mkLiteral "100%";
        expand = false;
      };

      element = {
        padding = mkLiteral "0px 2px";
        border-radius = mkLiteral "2px";
        spacing = mkLiteral "6px";
      };

      "element selected" = {
        background-color = mkLiteral "rgba(255,255,255,0.125)";
      };
    };
  };
}
