{
  config,
  inputs,
  class,
  self,
  ...
}:
{
  imports =
    if class == "nixos" then
      [ inputs.agenix.nixosModules.default ]
    else if class == "darwin" then
      [ inputs.agenix.darwinModules.default ]
    else
      [ ];

  age.identityPaths = [ "/home/${config.unravelled.system.mainUser}/.ssh/id_ed25519" ];

  age.secrets = {
    "soju-password" = {
      file = "${self}/secrets/soju-password.age";
      owner = config.unravelled.system.mainUser;
      group = "users";
      mode = "0400";
    };
  };
}
