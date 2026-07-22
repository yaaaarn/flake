{
  self,
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
let
  inherit (lib) mkAfter mkImageMediaOverride;

  rev = self.shortRev or "dirty";
  name = "${config.networking.hostName}-${config.system.nixos.release}-${rev}-${pkgs.stdenv.hostPlatform.uname.processor}";
in
{
  boot = {
    kernelParams = mkAfter [
      "noquiet"
      "copytoram"
    ];
  };

  users = {
    mutableUsers = false;

    users.${config.unravelled.system.mainUser} = {
      hashedPasswordFile = toString (pkgs.writeText "isoUserPassword" secrets.isoUserPassword);
    };
  };

  image = {
    baseName = mkImageMediaOverride name;
  };

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;

    appendToMenuLabel = " live";
  };

  services.journald = {
    storage = "none";
    forwardToSyslog = false;
    extraConfig = ''
      ForwardToConsole=no
      ForwardToWall=no
    '';
  };

  swapDevices = mkImageMediaOverride [ ];
  fileSystems = mkImageMediaOverride config.lib.isoFileSystems;
}
