{
  config,
  lib,
  pkgs,
  self',
  ...
}:

let
  inherit (lib) mkEnableOption mkOption mkIf optionalAttrs;
  inherit (lib.types) types;

  cfg = config.programs.ratune;

  passwordCmd =
    if cfg.server.passwordFile != null then
      "cat ${cfg.server.passwordFile}"
    else
      cfg.server.passwordCommand;

  tomlFormat = pkgs.formats.toml { };

  serverConfig = {
    server = {
      url = cfg.server.url;
      username = cfg.server.username;
    }
    // optionalAttrs (cfg.server.password != null) {
      password = cfg.server.password;
    }
    // optionalAttrs (passwordCmd != null) {
      password_command = passwordCmd;
    };
  };

  configValue = serverConfig // cfg.extraConfig;

  configFile = tomlFormat.generate "ratune-config.toml" configValue;

in
{
  options.programs.ratune = {
    enable = mkEnableOption "ratune, a terminal music player for Subsonic-compatible servers";

    package = mkOption {
      type = types.package;
      default = self'.packages.ratune;
      description = "The ratune package to use.";
    };

    server = {
      url = mkOption {
        type = types.str;
        default = "";
        description = "Subsonic server URL.";
      };

      username = mkOption {
        type = types.str;
        default = "";
        description = "Subsonic username.";
      };

      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Subsonic password (plaintext). Prefer passwordFile or passwordCommand.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to a file containing the Subsonic password (e.g. an agenix secret).";
      };

      passwordCommand = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Shell command that outputs the Subsonic password.";
      };
    };

    extraConfig = mkOption {
      type = types.attrsOf (types.attrsOf (types.oneOf [
        types.str
        types.int
        types.bool
      ]));
      default = {};
      description = "Additional ratune config.toml sections.";
      example = ''
        {
          player = {
            default_volume = 70;
            queue_loop = true;
          };
          theme = {
            preset = "dynamic";
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.length (lib.filter (x: x != null) [
          cfg.server.password
          cfg.server.passwordFile
          cfg.server.passwordCommand
        ]) <= 1;
        message = "programs.ratune.server: only one of password, passwordFile, or passwordCommand may be set.";
      }
    ];

    home.packages = [ cfg.package ];

    xdg.configFile."ratune/config.toml".source = configFile;
  };
}
