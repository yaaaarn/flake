{
  inputs,
  osConfig,
  lib,

  ...
}:
let
  inherit (lib) optionals;
in
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];
  services.flatpak = {
    enable = !osConfig.unravelled.profiles.iso.enable;
    packages = optionals osConfig.unravelled.profiles.perf.high.enable [
      {
        appId = "org.vinegarhq.Sober";
        origin = "flathub";
      }
    ];
  };

}
