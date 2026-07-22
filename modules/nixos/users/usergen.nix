{
  self,
  lib,
  pkgs,
  _class,
  config,
  secrets,
  ...
}: let
  inherit
    (lib)
    mkDefault
    mergeAttrsList
    optionalAttrs
    genAttrs
    ;
in {
  users.users = genAttrs config.unravelled.system.users (
    name:
      mergeAttrsList [
        (optionalAttrs (_class == "nixos") {
          home = "/home/${name}";
          isNormalUser = true;
          hashedPasswordFile = toString (pkgs.writeText "defaultUserPassword" secrets.defaultUserPassword);
          shell = pkgs.zsh;
          extraGroups = ["wheel"];
        })
      ]
  );
}
