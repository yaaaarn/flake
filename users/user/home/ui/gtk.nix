{
  lib,
  osConfig,
  config,
  pkgs,
  colors,
  ...
}:
let
  inherit (lib) mkIf;

  x = colors.x;

  schema = pkgs.gsettings-desktop-schemas;

  denseGtkSrc = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/pomegranar/dense-gtk/main/gtk.css";
    hash = "sha256-nMARY0S+0d+BeTzDc4N23/ja9e+E+rELBYpcVd/IMdw=";
  };

  gtkColors = ''
    ${builtins.readFile denseGtkSrc}

    :root {
      --accent-color: @accent_color;
      --accent-bg-color: @accent_bg_color;
      --accent-fg-color: @accent_fg_color;

      --destructive-bg-color: @destructive_bg_color;
      --destructive-fg-color: @destructive_fg_color;

      --error-bg-color: @error_bg_color;
      --error-fg-color: @error_fg_color;

      --window-bg-color: @window_bg_color;
      --window-fg-color: @window_fg_color;

      --view-bg-color: @view_bg_color;
      --view-fg-color: @view_fg_color;

      --headerbar-bg-color: @headerbar_bg_color;
      --headerbar-fg-color: @headerbar_fg_color;
      --headerbar-backdrop-color: @headerbar_backdrop_color;

      --popover-bg-color: @popover_bg_color;
      --popover-fg-color: @popover_fg_color;

      --card-bg-color: @card_bg_color;
      --card-fg-color: @card_fg_color;

      --dialog-bg-color: @dialog_bg_color;
      --dialog-fg-color: @dialog_fg_color;

      --overview-bg-color: @overview_bg_color;
      --overview-fg-color: @overview_fg_color;

      --sidebar-bg-color: @sidebar_bg_color; 
      --sidebar-fg-color: @sidebar_fg_color;
      --sidebar-backdrop-color: @sidebar_backdrop_color;
      --sidebar-border-color: @window_bg_color;

      --secondary-sidebar-bg-color: @secondary_sidebar_bg_color;
      --secondary-sidebar-fg-color: @secondary_sidebar_fg_color;

      --theme-unfocused-fg-color: @theme_unfocused_fg_color;
      --theme-unfocused-text-color: @theme_unfocused_text_color;
      --theme-unfocused-bg-color: @theme_unfocused_bg_color;
      --theme-unfocused-base-color: @theme_unfocused_base_color;
      --theme-unfocused-selected-bg-color: @theme_unfocused_selected_bg_color;
      --theme-unfocused-selected-fg-color: @theme_unfocused_selected_fg_color;
    }

    @define-color accent_color #${builtins.elemAt x 3};
    @define-color accent_bg_color #${builtins.elemAt x 3};
    @define-color accent_fg_color #${colors.background};

    @define-color destructive_bg_color #${builtins.elemAt x 1};
    @define-color destructive_fg_color #${colors.background};

    @define-color error_bg_color #${builtins.elemAt x 1};
    @define-color error_fg_color #${colors.background};

    @define-color window_bg_color #${colors.background};
    @define-color window_fg_color #${colors.foreground};

    @define-color view_bg_color #${colors.background};
    @define-color view_fg_color #${colors.foreground};

    @define-color headerbar_bg_color #${colors.background};
    @define-color headerbar_fg_color #${colors.foreground};
    @define-color headerbar_backdrop_color @window_bg_color;

    @define-color popover_bg_color #${colors.background};
    @define-color popover_fg_color #${colors.foreground};

    @define-color card_bg_color #${colors.background};
    @define-color card_fg_color #${colors.foreground};

    @define-color dialog_bg_color #${colors.background};
    @define-color dialog_fg_color #${colors.foreground};

    @define-color overview_bg_color #${colors.background};
    @define-color overview_fg_color #${colors.foreground};

    @define-color sidebar_bg_color #${colors.background}; 
    @define-color sidebar_fg_color #${colors.foreground};
    @define-color sidebar_backdrop_color @window_bg_color;
    @define-color sidebar_border_color @window_bg_color;

    @define-color secondary_sidebar_bg_color #${colors.background};
    @define-color secondary_sidebar_fg_color #${colors.foreground};

    /* Backdrop/unfocused states */
    @define-color theme_unfocused_fg_color @window_fg_color;
    @define-color theme_unfocused_text_color @view_fg_color;
    @define-color theme_unfocused_bg_color @window_bg_color;
    @define-color theme_unfocused_base_color @window_bg_color;
    @define-color theme_unfocused_selected_bg_color @accent_bg_color;
    @define-color theme_unfocused_selected_fg_color @accent_fg_color;

    /* more gtk3 compat */
    @define-color theme_bg_color @window_bg_color;
    @define-color theme_base_color @view_bg_color;
    @define-color theme_fg_color @window_fg_color;
    @define-color theme_text_color @view_fg_color;
    @define-color theme_selected_bg_color @accent_bg_color;
    @define-color theme_selected_fg_color @accent_fg_color;
  '';
in
{
  config = mkIf osConfig.unravelled.profiles.graphical.enable {
    xdg = {
      systemDirs.data = [ "${schema}/share/gsettings-schemas/${schema.name}" ];

      configFile = {
        "gtk-3.0/gtk.css".text = gtkColors;
        "gtk-4.0/gtk.css".text = gtkColors;
        "gtk-4.0/assets".source = "${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark/gtk-4.0/assets";
      };
    };

    dconf.settings = {
      "org/gnome/desktop/wm/preferences" = {
        button-layout = ":minimize,maximize,close";
      };
    };

    home.packages = [ pkgs.adw-gtk3 ];
    home.sessionVariables.GTK_USE_PORTAL = "1";

    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      cursorTheme = {
        name = "elementary";
        package = pkgs.pantheon.elementary-icon-theme;
      };
      font = {
        name = builtins.elemAt osConfig.fonts.fontconfig.defaultFonts.sansSerif 0;
        package = null;
        size = 9;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme.override {
          color = "adwaita";
        };
      };
      colorScheme = "dark";

      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        extraConfig = ''
          gtk-xft-antialias=1
          gtk-xft-hinting=1
          gtk-xft-hintstyle="hintslight"
          gtk-xft-rgba="rgb"
        '';
      };

      gtk3.extraConfig = {
        gtk-cursor-theme-size = 16;
        gtk-application-prefer-dark-theme = true;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-error-bell = 0;
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      };

      gtk4 = {
        theme = config.gtk.theme;
        extraConfig = config.gtk.gtk3.extraConfig;
      };
    };
  };
}
