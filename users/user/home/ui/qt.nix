{
  lib,
  osConfig,
  pkgs,
  config,
  colors,
  ...
}:
let
  inherit (lib) mkIf;
  x = colors.x;

  bg = colors.background;
  fg = colors.foreground;
  fg-alt = colors.foreground-alt;
  crust = colors.crust;
  accent = builtins.elemAt x 3;
  link = builtins.elemAt x 5;
  visited = builtins.elemAt x 6;
  white = builtins.elemAt x 15;
  muted = builtins.elemAt x 8;

  surface = colors.surface;

  aargb = alpha: hex: "#${alpha}${hex}";
  o = aargb "ff";
  ha = aargb "80";
  hd = aargb "40";
  hi = aargb "60";

  a = sep: f: builtins.concatStringsSep sep (f);
  c = a ",";

  # 0  WindowText      - General text on windows, labels, menus
  # 1  Button          - Button background
  # 2  Light           - Light bevel/highlight color
  # 3  Midlight        - Between Light and Button
  # 4  Dark            - Dark bevel/shadow color
  # 5  Mid             - Between Button and Dark
  # 6  Text            - Text in input fields and views
  # 7  BrightText      - High-contrast text
  # 8  ButtonText      - Text on buttons
  # 9  Base            - Background of inputs, lists, tables
  # 10 Window          - Main window background
  # 11 Shadow          - Deep shadow color
  # 12 Highlight       - Selection background
  # 13 HighlightedText - Text on selected items
  # 14 Link            - Unvisited hyperlinks
  # 15 LinkVisited     - Visited hyperlinks
  # 16 AlternateBase   - Alternate row background
  # 17 ToolTipBase     - Tooltip background
  # 18 ToolTipText     - Tooltip text
  # 19 PlaceholderText - Placeholder/hint text
  # 20 Accent          - Qt 6 accent color
  # 21 AccentText      - Text/icons using the accent color

  active = c [
    (o fg)
    (o bg)
    (o surface)
    (o surface)
    (o crust)
    (o crust)
    (o fg)
    (o white)
    (o fg)
    (o crust)
    (o bg)
    (o crust)
    (ha accent)
    (o crust)
    (o link)
    (o accent)
    (o crust)
    (o white)
    (o bg)
    (o visited)
    (ha accent)
    (o accent)
  ];

  inactive = c [
    (o fg)
    (o bg)
    (o surface)
    (o surface)
    (o crust)
    (o crust)
    (o fg)
    (o white)
    (o fg)
    (o crust)
    (o bg)
    (o crust)
    (ha accent)
    (o crust)
    (o link)
    (o accent)
    (o crust)
    (o white)
    (o bg)
    (o visited)
    (hi accent)
    (o accent)
  ];

  disabled = c [
    (o fg-alt)
    (o bg)
    (o surface)
    (o surface)
    (o crust)
    (o crust)
    (o fg-alt)
    (o white)
    (o fg-alt)
    (o crust)
    (o bg)
    (o crust)
    (o bg)
    (o bg)
    (o bg)
    (o bg)
    (o crust)
    (o white)
    (o bg)
    (o bg)
    (hd bg)
    (o muted)
  ];

  conf = ''
    [ColorScheme]
    active_colors=${active}
    disabled_colors=${disabled}
    inactive_colors=${inactive}
  '';
in
{
  config = mkIf osConfig.unravelled.profiles.graphical.enable {
    qt = {
      enable = true;
      platformTheme.name = "qtct";

      style = {
        name = "fusion";
        package = pkgs.qt6.qtbase;
      };

      qt6ctSettings = {
        Appearance = {
          style = "Fusion";
          icon_theme = config.gtk.iconTheme.name;
          standard_dialogs = "xdgdesktopportal";
          color_scheme_path = "~/.local/share/color-schemes/theme.conf";
          custom_palette = true;
        };
        Fonts = {
          fixed = "\"${builtins.elemAt osConfig.fonts.fontconfig.defaultFonts.monospace 0},9\"";
          general = "\"${builtins.elemAt osConfig.fonts.fontconfig.defaultFonts.sansSerif 0},9\"";
        };
      };

      qt5ctSettings = config.qt.qt6ctSettings;
    };

    home.file.".local/share/color-schemes/theme.conf".text = conf;

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };
}
