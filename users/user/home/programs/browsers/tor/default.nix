{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.unravelled.apps.browsers.tor.enable {
    home.packages = with pkgs; [ tor-browser ];
  };
}
