{ inputs, ... }:
{
  imports = [
    ./boot.nix
    ./usergen.nix

    # TODO: modularize
    ./system.nix
    ./networking.nix
    ./nix.nix

    ./desktops
    ./graphical
    ./youtube-local.nix
  ];
}
