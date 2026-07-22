{
  self',
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    optionals
    getExe
    getExe'
    ;
in
{
  imports = optionals (!osConfig.unravelled.profiles.laptop.enable) [
    ./conky
  ];

  config = mkIf osConfig.unravelled.options.desktops.labwc.enable {
    home.packages = with pkgs; [
      labwc-menu-generator
      wlr-randr
      self'.packages.greybox
    ];

    wayland.windowManager.labwc = {
      enable = true;
      systemd = {
        enable = true;
        extraCommands = [
          "systemctl --user start labwc-session.target"
        ];
      };

      environment = [
        "XDG_CURRENT_DESKTOP=labwc:wlroots"
        "XDG_SESSION_TYPE=wayland"
        "XDG_SESSION_DESKTOP=labwc"
        "XCURSOR_THEME=elementary"
        "XCURSOR_SIZE=16"
      ];

      rc = {
        windowRules = {
          windowRule = [
            {
              "@identifier" = "*";
              "@serverDecoration" = "no";
            }
          ];
        };
        core = {
          decoration = "server";
          gap = 0;
          adaptiveSync = "yes";
          allowTearing = "yes";
          reuseOutputMode = "yes";
          xwaylandPersistence = "yes";
        };
        desktops.prefix = "";
        theme = {
          name = "GreyBox";
          icon = "Obsidian-Teal";
          cornerRadius = 8;
          font = {
            "@name" = "Maple Mono NF CN";
            "@size" = 9;
          };
          dropShadows = "yes";
          dropShadowsOnTiled = "yes";
          keepBorder = "no";

        };
        libinput.device = {
          "@category" = "touchpad";
          naturalScroll = "yes";
          middleEmulation = "no";
        };
        keyboard = {
          default = true;
          keybind = [
            {
              "@key" = "W-t";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe pkgs.xdg-terminal-exec}";
              };
            }
            {
              "@key" = "W-f";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe' pkgs.xdg-utils "xdg-open"} https://";
              };
            }
            {
              "@key" = "W-e";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe' pkgs.xdg-utils "xdg-open"} ~";
              };
            }
            {
              "@key" = "W-Space";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe pkgs.rofi} -show drun";
              };
            }
            {
              "@key" = "W-S-e";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe pkgs.rofimoji} -a copy -r emoji --use-icons";
              };
            }
            {
              "@key" = "W-S-v";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe' pkgs.clipcat "clipcat-menu"}";
              };
            }
            {
              "@key" = "W-S-b";
              action = {
                "@name" = "Execute";
                "@command" = "qs ipc call sidebar toggle";
              };
            }
            {
              "@key" = "W-S-s";
              action = {
                "@name" = "Execute";
                "@command" = "qs ipc call screenshot screenshotToClipboard";
              };
            }
            {
              "@key" = "W-A-s";
              action = {
                "@name" = "Execute";
                "@command" = "qs ipc call screenshot screenshotAndUpload";
              };
            }
            {
              "@key" = "W-A-Escape";
              action = {
                "@name" = "Exit";
              };
            }
            {
              "@key" = "W-q";
              action = {
                "@name" = "Close";
              };
            }
            {
              "@key" = "W-S-q";
              action = {
                "@name" = "Kill";
              };
            }

            # multimedia
            {
              "@key" = "XF86AudioRaiseVolume";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
              };
            }
            {
              "@key" = "XF86AudioLowerVolume";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.05- -l 1.0";
              };
            }
            {
              "@key" = "XF86AudioMute";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
              };
            }
            {
              "@key" = "XF86AudioMicMute";
              action = {
                "@name" = "Execute";
                "@command" = "${getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              };
            }
          ];
        };
      };

      menu = [
        {
          menuId = "root-menu";
          label = "";
          execute = "sh ~/.local/bin/menu.sh";
        }
      ];
    };

    home.file.".local/bin/menu.sh".source = ./menu.sh;

  };
}
