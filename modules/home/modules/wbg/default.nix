{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    concatStringsSep
    getExe
    optionals
    ;
  inherit (lib.types) types;

  cfg = config.services.wbg;
in
{
  options.services.wbg = {
    enable = mkEnableOption "the super simple wallpaper application for Wayland compositors";

    package = mkOption {
      type = types.package;
      default = pkgs.wbg;
      description = "The wbg package to use.";
    };

    stretch = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to stretch the wallpaper to fill the screen.";
    };

    image = mkOption {
      type = types.path;
      description = "Path to the wallpaper image (required).";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra command-line arguments to pass to wbg.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.wbg = {
      Unit = {
        Description = "Wayland Wallpaper Application";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = concatStringsSep " " (
          [ (getExe cfg.package) ]
          ++ optionals cfg.stretch [ "-s" ]
          ++ [ cfg.image ]
          ++ cfg.extraArgs
        );
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
