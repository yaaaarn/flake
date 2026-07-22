{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in
{
  boot = {
    loader = {
      limine.enable = true; 

      efi.canTouchEfiVariables = true;
    };

    kernelPackages = mkDefault pkgs.linuxPackages_latest;
  };
}
