{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) optionals;
in
{
  imports = [
    ./apps
    ./browsers
    ./editors

    ./graphical.nix
    ./media.nix
  ]
  ++ optionals (!pkgs.stdenv.isDarwin && osConfig.unravelled.profiles.full.enable) [
    ./flatpak.nix
  ];

  services = {
    syncthing.enable = !osConfig.unravelled.profiles.iso.enable;
  };
}
