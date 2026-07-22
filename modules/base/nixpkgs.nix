{
  inputs,
  lib,
  class,
  ...
}:
let
  inherit (lib) optionals;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowAliases = false;
    };

    overlays = [
      inputs.osu-lazer-flake.overlays.default
    ]
    ++ optionals (class != "darwin") [
      inputs.niri.overlays.niri
      inputs.nix-minecraft.overlay
    ];
  };
}
