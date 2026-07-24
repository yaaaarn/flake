{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkOption mkIf;
  inherit (lib.types) bool enum;
in
{
  options.unravelled.apps.browsers = {
    firefox.enable = mkOption {
      type = bool;
      default = true;
      description = "Whether to enable the Firefox web browser";
    };

    helium.enable = mkOption {
      type = bool;
      default = true;
      description = "Whether to enable the Helium web browser";
    };

    tor.enable = mkOption {
      type = bool;
      default = true;
      description = "Whether to enable the Tor browser";
    };

    default = mkOption {
      type = enum [ "firefox" "helium" "tor" ];
      default = "helium";
      description = "The default browser for MIME type associations";
    };
  };

  imports =
    if osConfig.unravelled.profiles.graphical.enable then
      [ ./firefox ./helium ./tor ]
    else
      [ ];

  config = let
    firefoxEnabled = config.unravelled.apps.browsers.firefox.enable;
    heliumEnabled = config.unravelled.apps.browsers.helium.enable;
    default = config.unravelled.apps.browsers.default;
  in mkIf (firefoxEnabled || heliumEnabled) {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "${default}.desktop" ];
      "x-scheme-handler/http" = [ "${default}.desktop" ];
      "x-scheme-handler/https" = [ "${default}.desktop" ];
    };
  };
}
