{
  osConfig,
  colors,
  ...
}:
let
  x = colors.x;
in
{
  programs.kitty = {
    enable = osConfig.unravelled.profiles.graphical.enable;

    font = {
      name = "New Heterodox Mono";
      package = null;
      size = 9;
    };

    enableGitIntegration = true;
    shellIntegration.enableZshIntegration = true;

    settings = {
      term = "xterm-256color";

      window_padding_width = 8;

      foreground = "#${colors.foreground}";
      background = "#${colors.background}";

      color0 = "#${builtins.elemAt x 0}";
      color1 = "#${builtins.elemAt x 1}";
      color2 = "#${builtins.elemAt x 2}";
      color3 = "#${builtins.elemAt x 3}";
      color4 = "#${builtins.elemAt x 4}";
      color5 = "#${builtins.elemAt x 5}";
      color6 = "#${builtins.elemAt x 6}";
      color7 = "#${builtins.elemAt x 7}";
      color8 = "#${builtins.elemAt x 8}";
      color9 = "#${builtins.elemAt x 9}";
      color10 = "#${builtins.elemAt x 10}";
      color11 = "#${builtins.elemAt x 11}";
      color12 = "#${builtins.elemAt x 12}";
      color13 = "#${builtins.elemAt x 13}";
      color14 = "#${builtins.elemAt x 14}";
      color15 = "#${builtins.elemAt x 15}";

      selection_background = "#${builtins.elemAt x 2}";
      selection_foreground = "#${colors.background}";

      cursor = "#${builtins.elemAt x 2}";
      cursor_text_color = "#${colors.background}";

      cursor_trail = 1;
      cursor_trail_start_threshold = 0;
    };
  };

  xdg.terminal-exec.settings.default =
    if osConfig.unravelled.profiles.graphical.enable then [ "kitty.desktop" ] else [ ];
}
