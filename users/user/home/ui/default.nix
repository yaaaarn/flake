{ pkgs, ... }:
{
  imports = if !pkgs.stdenv.isDarwin then [
    ./gtk.nix
    ./qt.nix
  ] else [];
}
