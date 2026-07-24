{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
in
{
  options.unravelled.apps.editors = {
    neovim.enable = mkOption {
      type = bool;
      default = true;
      description = "Whether to enable Neovim";
    };

    zed.enable = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable Zed editor";
    };
  };

  imports = [
    ./zed
    ./neovim
  ];
}
