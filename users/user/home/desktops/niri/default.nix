{
  osConfig,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  workspaces = builtins.genList (x: x + 1) 9;
  workspaceBinds = builtins.foldl' (a: b: a // b) { } (
    map (ws: {
      "Mod+${toString ws}".action.focus-workspace = ws;
      "Mod+Shift+${toString ws}".action.move-column-to-workspace = ws;
    }) workspaces
  );

  radius = 12.0;

  apps = [
    "^kitty$"
    "^dev.zed.Zed$"
    "^vesktop$"
    "^equibop$"
    "^pcmanfm$"
  ];

  inherit (lib) mkIf getExe getExe';
in
{
  imports =
    if osConfig.unravelled.apps.desktops.niri.enable then [ inputs.niri.homeModules.niri ] else [ ];

  config = mkIf osConfig.unravelled.apps.desktops.niri.enable {
    home.packages = with pkgs; [
      xwayland-satellite
      pantheon.elementary-sound-theme
    ];

    programs.niri = {
      enable = true;
      inherit (osConfig.programs.niri) package;
      settings = {
        debug = {
          disable-cursor-plane = { };
          honor-xdg-activation-with-invalid-serial = { };
        };

        cursor = {
          theme = config.gtk.cursorTheme.name;
          size = config.gtk.gtk3.extraConfig.gtk-cursor-theme-size;
        };

        spawn-at-startup = [ ];

        environment = {
          XDG_CURRENT_DESKTOP = "niri";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "niri";
        };

        prefer-no-csd = true;

        clipboard.disable-primary = true;

        layer-rules = [
          {
            matches = [
              { namespace = "qs-blurred"; }
            ];
            place-within-backdrop = true;
          }
        ];

        recent-windows = {
          highlight = {
            active-color = "#999999ff";
            urgent-color = "#ff9999ff";
            padding = 8;
            corner-radius = 8;
          };
        };

        window-rules = [
          {
            clip-to-geometry = true;
            geometry-corner-radius = {
              top-left = radius;
              top-right = radius;
              bottom-left = radius;
              bottom-right = radius;
            };
            background-effect = mkIf osConfig.unravelled.profiles.perf.high.enable {
              blur = true;
              xray = false;
            };
          }
        ]
        ++ lib.optionals (osConfig.unravelled.profiles.perf.low.enable != true) [
          {
            matches = map (app: {
              app-id = app;
              is-focused = true;
            }) apps;
            opacity = 0.95;
          }
          {
            matches = map (app: {
              app-id = app;
              is-focused = false;
            }) apps;
            opacity = 0.98;
          }
        ];

        input = {
          touchpad = {
            enable = true;
            tap = true;
            natural-scroll = true;
            click-method = "clickfinger";
            middle-emulation = false;
          };

          mouse = {
            accel-profile = "flat";
            # scroll-method = "on-button-down";
          };

          warp-mouse-to-focus.enable = true;
          # focus-follows-mouse.enable = true;
        };

        layout = {
          gaps = 4;

          background-color = "rgba(0,0,0,0)";

          center-focused-column = "never";

          shadow = {
            enable = osConfig.unravelled.profiles.perf.high.enable;
            color = "rgba(0,0,0,0.3)";
            offset = {
              x = 0;
              y = 0;
            };
          };

          default-column-width = {
            proportion = 0.4;
          };

          focus-ring = {
            enable = false;
            width = 1;
            active = {
              color = "#ffffff55";
            };
            urgent = {
              color = "#9b0000aa";
            };
          };
        };

        overview = {
          zoom = 0.5;
        };

        blur = {
          enable = mkIf (osConfig.unravelled.profiles.perf.low.enable != true) true;
          passes = 1;
          offset = 2.0;
          noise = 0.01;
          saturation = 1.5;
        };

        animations = mkIf (osConfig.unravelled.profiles.perf.low.enable != true) {
          workspace-switch = {
            enable = true;
            kind.spring = {
              damping-ratio = 0.65;
              stiffness = 523;
              epsilon = 0.0001;
            };
          };

          horizontal-view-movement = {
            enable = true;
            kind.spring = {
              damping-ratio = 0.50;
              stiffness = 523;
              epsilon = 0.0001;
            };
          };

          overview-open-close = {
            enable = true;
            kind.spring = {
              damping-ratio = 0.60;
              stiffness = 503;
              epsilon = 0.0001;
            };
          };

          window-movement = {
            enable = true;
            kind.spring = {
              damping-ratio = 0.60;
              stiffness = 300;
              epsilon = 0.0001;
            };
          };

          window-resize = {
            enable = true;
            kind.spring = {
              damping-ratio = 0.30;
              stiffness = 400;
              epsilon = 0.0001;
            };
          };

          window-open = {
            enable = true;
            kind.easing = {
              duration-ms = 500;
              curve = "ease-out-expo";
            };
            custom-shader = ''
              vec4 fall_from_top(vec3 coords_geo, vec3 size_geo) {
                float progress = niri_clamped_progress * niri_clamped_progress;
                vec2 coords = (coords_geo.xy - vec2(0.5, 0.0)) * size_geo.xy;
                coords.y += (1.0 - progress) * 1440.0;
                float random = (niri_random_seed - 0.5) / 2.0;
                random = sign(random) - random;
                float max_angle = 0.5 * random;
                float angle = (1.0 - progress) * max_angle;
                mat2 rotate = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
                coords = rotate * coords;
                coords_geo = vec3(coords / size_geo.xy + vec2(0.5, 0.0), 1.0);
                vec3 coords_tex = niri_geo_to_tex * coords_geo;
                return texture2D(niri_tex, coords_tex.st);
              }

              vec4 open_color(vec3 coords_geo, vec3 size_geo) {
                return fall_from_top(coords_geo, size_geo);
              }
            '';
          };

          window-close = {
            enable = true;
            kind.easing = {
              duration-ms = 1000;
              curve = "linear";
            };
            custom-shader = ''
              vec4 fall_and_rotate(vec3 coords_geo, vec3 size_geo) {
                float progress = niri_clamped_progress * niri_clamped_progress;
                vec2 coords = (coords_geo.xy - vec2(0.5, 1.0)) * size_geo.xy;
                coords.y -= progress * 1440.0;
                float random = (niri_random_seed - 0.5) / 2.0;
                random = sign(random) - random;
                float max_angle = 0.5 * random;
                float angle = progress * max_angle;
                mat2 rotate = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
                coords = rotate * coords;
                coords_geo = vec3(coords / size_geo.xy + vec2(0.5, 1.0), 1.0);
                vec3 coords_tex = niri_geo_to_tex * coords_geo;
                vec4 color = texture2D(niri_tex, coords_tex.st);
                color.a *= (1.0 - progress);

                return color;
              }

              vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                return fall_and_rotate(coords_geo, size_geo);
              }
            '';
          };
        };

        binds = {
          "Mod+Alt+Escape".action.quit = { };

          "Mod+Q" = {
            repeat = false;
            action.close-window = { };
          };

          "Mod+O" = {
            repeat = false;
            action.toggle-overview = { };
          };

          "Mod+Space".action.spawn = [
            (getExe pkgs.rofi)
            "-show"
            "drun"
          ];
          "Mod+Shift+E".action.spawn = [
            (getExe pkgs.rofimoji)
            "-a"
            "copy"
            "-r"
            "emoji"
            "--use-icons"
          ];

          "Mod+V".action.toggle-window-floating = { };

          "Mod+Shift+V".action.spawn = [ (getExe' pkgs.clipcat "clipcat-menu") ];

          "Mod+T".action.spawn = [ (getExe pkgs.xdg-terminal-exec) ];
          "Mod+F".action.spawn = [
            (getExe' pkgs.xdg-utils "xdg-open")
            "https://"
          ];
          "Mod+E".action.spawn = [
            (getExe' pkgs.gtk3 "gtk-launch")
            "${builtins.elemAt config.xdg.mimeApps.defaultApplications."inode/directory" 0}"
          ];

          "Mod+B".action.maximize-column = { };

          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";

          "Mod+Left".action.focus-column-left = { };
          "Mod+Right".action.focus-column-right = { };

          "Mod+Up".action.focus-workspace-up = { };
          "Mod+Down".action.focus-workspace-down = { };
          "Mod+WheelScrollDown".action.focus-workspace-down = { };
          "Mod+WheelScrollUp".action.focus-workspace-up = { };

          "Mod+Shift+Left".action.move-column-left = { };
          "Mod+Shift+Right".action.move-column-right = { };
          "Mod+Shift+Up".action.move-window-up = { };
          "Mod+Shift+Down".action.move-window-down = { };

          "Mod+Shift+B".action.spawn = [
            (getExe pkgs.quickshell)
            "ipc"
            "call"
            "sidebar"
            "toggle"
          ];

          "Mod+Shift+S".action.spawn = [
            (getExe pkgs.quickshell)
            "ipc"
            "call"
            "screenshot"
            "screenshotToClipboard"
          ];
          "Mod+Alt+S".action.spawn = [
            (getExe pkgs.quickshell)
            "ipc"
            "call"
            "screenshot"
            "screenshotAndUpload"
          ];

          "Mod+Shift+P".action.power-off-monitors = { };

          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn = [
              (getExe pkgs.playerctl)
              "play-pause"
            ];
          };
          "XF86AudioStop" = {
            allow-when-locked = true;
            action.spawn = [
              (getExe pkgs.playerctl)
              "stop"
            ];
          };
          "XF86AudioPrev" = {
            allow-when-locked = true;
            action.spawn = [
              (getExe pkgs.playerctl)
              "previous"
            ];
          };
          "XF86AudioNext" = {
            allow-when-locked = true;
            action.spawn = [
              (getExe pkgs.playerctl)
              "next"
            ];
          };

          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn-sh = "${getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn-sh = "${getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.05- -l 1.0";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn-sh = "${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action.spawn-sh = "${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          };

          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action.spawn-sh = "${getExe pkgs.brightnessctl} --class=backlight set +5%";
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action.spawn-sh = "${getExe pkgs.brightnessctl} --class=backlight set 5%-";
          };
          "XF86KbdBrightnessUp" = {
            allow-when-locked = true;
            action.spawn-sh = "${getExe pkgs.brightnessctl} -d smc::kbd_backlight set +5%";
          };
          "XF86KbdBrightnessDown" = {
            allow-when-locked = true;
            action.spawn-sh = "${getExe pkgs.brightnessctl} -d smc::kbd_backlight set 5%-";
          };
        }
        // workspaceBinds;
      };
    };

  };
}
