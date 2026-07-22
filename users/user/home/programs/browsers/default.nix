{
  lib,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf optionals;

  firefoxEnabled = osConfig.unravelled.options.browsers.firefox.enable;
  heliumEnabled = osConfig.unravelled.options.browsers.helium.enable;

  browser = (if heliumEnabled then "helium" else "firefox");
in
{
  imports =
    if osConfig.unravelled.profiles.graphical.enable then
      optionals firefoxEnabled [ ./firefox ]
      ++ optionals heliumEnabled [ ./helium ]
      ++ optionals osConfig.unravelled.profiles.full.enable [ ./tor ]
    else
      [ ];

  config = mkIf (firefoxEnabled || heliumEnabled) {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "${browser}.desktop" ];
      "x-scheme-handler/http" = [ "${browser}.desktop" ];
      "x-scheme-handler/https" = [ "${browser}.desktop" ];
    };
  };
}
