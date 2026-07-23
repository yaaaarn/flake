{
  lib,
  inputs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf optionals;
in
{
  imports = optionals osConfig.unravelled.apps.editors.neovim.enable [
    inputs.nixvim.homeModules.nixvim
  ];

  config = mkIf osConfig.unravelled.apps.editors.neovim.enable {
    programs.nixvim = {
      imports = [ ./nixvim.nix ];

      nixpkgs.source = inputs.nixpkgs;
    };

    home.sessionVariables.EDITOR = "nvim";
  };
}
