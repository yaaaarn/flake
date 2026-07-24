{
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  config = mkIf config.unravelled.apps.editors.neovim.enable {
    programs.nixvim = {
      imports = [ ./nixvim.nix ];

      nixpkgs.source = inputs.nixpkgs;
    };

    home.sessionVariables.EDITOR = "nvim";
  };
}
