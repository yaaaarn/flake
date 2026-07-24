{
  self',
  pkgs,
  osConfig,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    optionals
    getExe
    getExe'
    ;

  kb = import ../shared/keybinds.nix { inherit pkgs config; };

  workspaceBinds = map (ws: {
    "@key" = "W-${toString ws}";
    action = {
      "@name" = "Desktop";
      "@command" = toString ws;
    };
  }) (lib.range 1 9)
  ++ map (ws: {
    "@key" = "W-S-${toString ws}";
    action = {
      "@name" = "SendToDesktop";
      "@command" = toString ws;
    };
  }) (lib.range 1 9);
in
{
  imports = optionals (!osConfig.unravelled.profiles.laptop.enable) [
    ./conky
  ];

  config = mkIf osConfig.unravelled.desktops.labwc.enable {
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
                "@command" = lib.concatStringsSep " " kb.terminal;
              };
            }
            {
              "@key" = "W-f";
              action = {
                "@name" = "Execute";
                "@command" = lib.concatStringsSep " " kb.browser;
              };
            }
            {
              "@key" = "W-e";
              action = {
                "@name" = "Execute";
                "@command" = lib.concatStringsSep " " kb.fileManager';
              };
            }
            {
              "@key" = "W-Space";
              action = {
                "@name" = "Execute";
                "@command" = lib.concatStringsSep " " kb.rofi;
              };
            }
            {
              "@key" = "W-S-e";
              action = {
                "@name" = "Execute";
                "@command" = lib.concatStringsSep " " kb.rofimoji;
              };
            }
            {
              "@key" = "W-S-v";
              action = {
                "@name" = "Execute";
                "@command" = lib.concatStringsSep " " kb.clipboard;
              };
            }
            {
              "@key" = "W-S-b";
              action = {
                "@name" = "Execute";
                "@command" = lib.concatStringsSep " " kb.sidebar;
              };
            }
            {
              "@key" = "W-S-s";
              action = {
                "@name" = "Execute";
                "@command" = lib.concatStringsSep " " kb.screenshot;
              };
            }
            {
              "@key" = "W-A-s";
              action = {
                "@name" = "Execute";
                "@command" = lib.concatStringsSep " " kb.screenshotUpload;
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
                "@command" = kb.volumeUp;
              };
            }
            {
              "@key" = "XF86AudioLowerVolume";
              action = {
                "@name" = "Execute";
                "@command" = kb.volumeDown;
              };
            }
            {
              "@key" = "XF86AudioMute";
              action = {
                "@name" = "Execute";
                "@command" = kb.mute;
              };
            }
            {
              "@key" = "XF86AudioMicMute";
              action = {
                "@name" = "Execute";
                "@command" = kb.micMute;
              };
            }

            # workspaces
            {
              "@key" = "W-bracketleft";
              action = {
                "@name" = "Desktop";
                "@command" = "previous";
              };
            }
            {
              "@key" = "W-bracketright";
              action = {
                "@name" = "Desktop";
                "@command" = "next";
              };
            }
          ]
          ++ workspaceBinds;
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
