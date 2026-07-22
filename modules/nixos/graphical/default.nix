{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [
    ./fonts.nix
    ./pipewire.nix
  ];

  config = mkIf config.unravelled.profiles.graphical.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    services.displayManager.ly = {
      enable = true;
      settings = {
        allow_empty_password = false;
        animation = "gameoflife";
        box_title = "yarn industries";
      };
    };
  };
}
