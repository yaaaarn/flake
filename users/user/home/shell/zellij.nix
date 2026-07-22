{ colors, ... }:
let
  h = hex: "#${hex}";
  x = colors.x;
in
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    enableFishIntegration = false;
    enableBashIntegration = false;

    settings = {
      theme = "default";
      show_startup_tips = false;
      copy_on_select = false;
    };

    themes = {
      default.themes.default = {
        text_unselected = {
          base = h colors.foreground;
          background = h colors.background;
          emphasis_0 = h (builtins.elemAt x 9);
          emphasis_1 = h (builtins.elemAt x 12);
          emphasis_2 = h (builtins.elemAt x 11);
          emphasis_3 = h (builtins.elemAt x 15);
        };
        text_selected = {
          base = h colors.foreground;
          background = h colors.surface;
          emphasis_0 = h (builtins.elemAt x 9);
          emphasis_1 = h (builtins.elemAt x 12);
          emphasis_2 = h (builtins.elemAt x 11);
          emphasis_3 = h (builtins.elemAt x 15);
        };
        ribbon_selected = {
          base = h colors.background;
          background = h (builtins.elemAt x 3);
          emphasis_0 = h (builtins.elemAt x 1);
          emphasis_1 = h (builtins.elemAt x 9);
          emphasis_2 = h (builtins.elemAt x 15);
          emphasis_3 = h (builtins.elemAt x 13);
        };
        ribbon_unselected = {
          base = h colors.foreground;
          background = h colors.surface;
          emphasis_0 = h (builtins.elemAt x 1);
          emphasis_1 = h colors.foreground;
          emphasis_2 = h (builtins.elemAt x 13);
          emphasis_3 = h (builtins.elemAt x 15);
        };
        table_title = {
          base = h (builtins.elemAt x 13);
          background = h colors.background;
          emphasis_0 = h (builtins.elemAt x 9);
          emphasis_1 = h (builtins.elemAt x 12);
          emphasis_2 = h (builtins.elemAt x 11);
          emphasis_3 = h (builtins.elemAt x 15);
        };
        table_cell_selected = {
          base = h colors.foreground;
          background = h colors.surface;
          emphasis_0 = h (builtins.elemAt x 9);
          emphasis_1 = h (builtins.elemAt x 12);
          emphasis_2 = h (builtins.elemAt x 11);
          emphasis_3 = h (builtins.elemAt x 15);
        };
        table_cell_unselected = {
          base = h colors.foreground;
          background = h colors.background;
          emphasis_0 = h (builtins.elemAt x 9);
          emphasis_1 = h (builtins.elemAt x 12);
          emphasis_2 = h (builtins.elemAt x 11);
          emphasis_3 = h (builtins.elemAt x 15);
        };
        list_selected = {
          base = h colors.foreground;
          background = h colors.surface;
          emphasis_0 = h (builtins.elemAt x 9);
          emphasis_1 = h (builtins.elemAt x 12);
          emphasis_2 = h (builtins.elemAt x 11);
          emphasis_3 = h (builtins.elemAt x 15);
        };
        list_unselected = {
          base = h colors.foreground;
          background = h colors.background;
          emphasis_0 = h (builtins.elemAt x 9);
          emphasis_1 = h (builtins.elemAt x 12);
          emphasis_2 = h (builtins.elemAt x 11);
          emphasis_3 = h (builtins.elemAt x 15);
        };
        frame_selected = {
          base = h (builtins.elemAt x 13);
          background = h colors.background;
          emphasis_0 = h (builtins.elemAt x 9);
          emphasis_1 = h (builtins.elemAt x 12);
          emphasis_2 = h (builtins.elemAt x 15);
          emphasis_3 = h colors.background;
        };
        frame_highlight = {
          base = h (builtins.elemAt x 1);
          background = h colors.background;
          emphasis_0 = h (builtins.elemAt x 15);
          emphasis_1 = h (builtins.elemAt x 9);
          emphasis_2 = h (builtins.elemAt x 9);
          emphasis_3 = h (builtins.elemAt x 9);
        };
        exit_code_success = {
          base = h (builtins.elemAt x 11);
          background = h colors.background;
          emphasis_0 = h (builtins.elemAt x 12);
          emphasis_1 = h colors.background;
          emphasis_2 = h (builtins.elemAt x 15);
          emphasis_3 = h (builtins.elemAt x 13);
        };
        exit_code_error = {
          base = h (builtins.elemAt x 1);
          background = h colors.background;
          emphasis_0 = h (builtins.elemAt x 10);
          emphasis_1 = h colors.background;
          emphasis_2 = h colors.background;
          emphasis_3 = h colors.background;
        };
        multiplayer_user_colors = {
          player_1 = h (builtins.elemAt x 15);
          player_2 = h (builtins.elemAt x 13);
          player_3 = h colors.background;
          player_4 = h (builtins.elemAt x 10);
          player_5 = h (builtins.elemAt x 12);
          player_6 = h colors.background;
          player_7 = h (builtins.elemAt x 1);
          player_8 = h colors.background;
          player_9 = h colors.background;
          player_10 = h colors.background;
        };
      };
    };
  };

}
