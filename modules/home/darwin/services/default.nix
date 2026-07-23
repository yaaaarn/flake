{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption mkIf getExe optionals optionalString escape collect mapAttrsRecursive replaceStrings;
  inherit (lib.types) types;
  inherit (lib.generators) toINI mkKeyValueDefault mkValueStringDefault;
  inherit (builtins) concatStringsSep isAttrs isString;
  cfg = config.services.qbittorrent;

  gendeepINI = toINI {
    mkKeyValue =
      let
        sep = "=";
      in
      k: v:
      if isAttrs v then
        concatStringsSep "\n" (
          collect isString (
            mapAttrsRecursive (
              path: value:
              "${escape [ sep ] (concatStringsSep "\\" ([ k ] ++ path))}${sep}${
                replaceStrings [ "\n" ] [ "\\n" ] (mkValueStringDefault { } value)
              }"
            ) v
          )
        )
      else
        mkKeyValueDefault { } sep k v;
  };

  configFile = pkgs.writeText "qBittorrent.ini" (gendeepINI cfg.serverConfig);

  confPath = "${cfg.profileDir}/qBittorrent/config/qBittorrent.ini";
in
{
  options.services.qbittorrent = {
    enable = mkEnableOption "qbittorrent, BitTorrent client";

    package = mkPackageOption pkgs "qbittorrent-nox" { };

    profileDir = mkOption {
      type = types.path;
      default = "${config.home.homeDirectory}/.config/qBittorrent";
      description = ''
        The path passed to qbittorrent via `--profile`.
        qBittorrent places its `config/qBittorrent.conf` inside a
        `qBittorrent/` sub-directory of this path.
      '';
    };

    webuiPort = mkOption {
      default = 8080;
      type = types.nullOr types.port;
      description = "The port passed to qbittorrent via `--webui-port`.";
    };

    torrentingPort = mkOption {
      default = null;
      type = types.nullOr types.port;
      description = "The port passed to qbittorrent via `--torrenting-port`.";
    };

    serverConfig = mkOption {
      default = { };
      type = types.submodule {
        freeformType = types.attrsOf (types.attrsOf types.anything);
      };
      description = ''
        Free-form settings mapped to the {file}`qBittorrent.conf` file in the
        profile directory. The config file is copied into place on every
        launch via `install -Dm600`, so qBittorrent can still write session
        state to it freely, and your Nix-managed values are re-applied on the
        next restart.

        Refer to [Explanation-of-Options-in-qBittorrent](https://github.com/qbittorrent/qBittorrent/wiki/Explanation-of-Options-in-qBittorrent).
        The `Password_PBKDF2` format is unique — use
        [this tool](https://codeberg.org/feathecutie/qbittorrent_password) to
        generate it, or let qBittorrent create it via the web UI first.

        An alternative web UI (e.g. VueTorrent) can be set like this:
        ```nix
        {
          Preferences.WebUI = {
            AlternativeUIEnabled = true;
            RootFolder = "''${pkgs.vuetorrent}/share/vuetorrent";
          };
        }
        ```
      '';
      example = literalExpression ''
        {
          LegalNotice.Accepted = true;
          Preferences = {
            WebUI = {
              Username = "user";
              Password_PBKDF2 = "@ByteArray(...)";
            };
            General.Locale = "en";
          };
        }
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra arguments passed to qbittorrent-nox. See `qbittorrent-nox -h`
        or the [source code](https://github.com/qbittorrent/qBittorrent/blob/master/src/app/cmdoptions.cpp)
        for available options.
      '';
      example = [ "--confirm-legal-notice" ];
    };
  };

  config = mkIf cfg.enable {
    # Ensure the config directory exists before the agent starts.
    home.activation.qbittorrentDirs = hm.dag.entryBefore [ "launchd" ] ''
      $DRY_RUN_CMD mkdir -p "${cfg.profileDir}/qBittorrent/config"
    '';

    launchd.agents.qbittorrent = {
      enable = true;
      config = {
        # launchd has no ExecStartPre, so we wrap in a shell.
        # install -Dm600 copies the Nix store config into the mutable profile
        # dir each launch — matching the NixOS ExecStartPre pattern — so
        # qBittorrent can write session state freely while Nix values win on
        # next restart.
        ProgramArguments =
          let
            args = concatStringsSep " " (
              [ "--profile=${lib.escapeShellArg cfg.profileDir}" ]
              ++ optionals (cfg.webuiPort != null) [ "--webui-port=${toString cfg.webuiPort}" ]
              ++ optionals (cfg.torrentingPort != null) [ "--torrenting-port=${toString cfg.torrentingPort}" ]
              ++ map lib.escapeShellArg cfg.extraArgs
            );
            installStep = optionalString (cfg.serverConfig != { }) ''
              ${pkgs.coreutils}/bin/install -Dm600 ${configFile} "${confPath}" &&
            '';
          in
          [
            "/bin/sh"
            "-c"
            "${installStep}exec ${getExe cfg.package} ${args}"
          ];
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "${cfg.profileDir}/qbittorrent.log";
        StandardErrorPath = "${cfg.profileDir}/qbittorrent.log";
      };
    };
  };
}

