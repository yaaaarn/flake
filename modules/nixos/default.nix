{ inputs, ... }:
{
  imports = [
    ./boot.nix
    ../../users/usergen.nix

    # TODO: modularize
    ./system.nix
    ./networking.nix
    ./nix.nix

    ./desktops
    ./graphical
  ];
}
