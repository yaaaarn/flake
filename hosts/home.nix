{
  lib,
  self,
  self',
  config,
  inputs,
  inputs',
  class,
  pkgs,
  colors,
  secrets,
  ...
}:
let
  inherit (lib) genAttrs mkIf;
in
{
  imports = [ inputs.home-manager."${class}Modules".home-manager ];

  users.users = mkIf pkgs.stdenv.isDarwin (
    genAttrs config.unravelled.system.users (name: {
      home = "/Users/${name}";
    })
  );

  home-manager = {
    verbose = false;
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "bak";

    users = genAttrs config.unravelled.system.users (name: {
      imports = [ ../users/${name}/home ];
    });

    extraSpecialArgs = {
      inherit
        self
        self'
        inputs
        inputs'
        class
        pkgs
        colors
        secrets
        ;
    };

    sharedModules = [
      "${self}/modules/home/default.nix"
      ../hosts/${config.networking.hostName}/home.nix
    ];
  };
}
