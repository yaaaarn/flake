{ inputs, ... }:
{
  imports = [
    ./boot.nix
    ./users

    # TODO: modularize
    ./system.nix
    ./networking.nix
    ./nix.nix

    ./desktops
    ./graphical
  ];
}
