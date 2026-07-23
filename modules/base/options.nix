{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption optional;
  inherit (lib.types) enum listOf str;
in
{
  options.unravelled = {
    system = {
      mainUser = mkOption {
        type = enum config.unravelled.system.users;
        description = "The username of the main user for your system";
        default = builtins.elemAt config.unravelled.system.users 0;
      };

      users = mkOption {
        type = listOf str;
        default = [ "user" ];
        description = ''
          A list of users that you wish to declare as your non-system users. The first username
          in the list will be treated as your main user unless {option}`unravelled.system.mainUser` is set.
        '';
      };
    };

    apps = {
      wallpaper = mkOption {
        type = str;
        default = "taiko-10826813.jpg";
        description = "The name of the wallpaper file to use for your system";
      };

      desktops = {
        niri.enable = mkEnableOption "Niri desktop environment";

        labwc.enable = mkEnableOption "Labwc desktop environment";
      };

      browsers = {
        helium.enable = mkEnableOption "Helium browser";

        firefox.enable = mkEnableOption "Firefox browser";
      };

      editors = {
        neovim.enable = mkEnableOption "Neovim editor";

        zed.enable = mkEnableOption "Zed editor";
      };
    };
  };

  config.warnings = optional (config.unravelled.system.users == [ ]) ''
    You have not added any users to be supported by your system. You may end up with an unbootable system!

    Consider setting {option}`config.unravelled.system.users` in your configuration
  '';
}
