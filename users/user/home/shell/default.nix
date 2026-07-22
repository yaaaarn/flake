{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) getExe mkIf;

  cmd = if pkgs.stdenv.isDarwin then "darwin" else "os";
  flakeDir = "${config.home.homeDirectory}/flake";
in
{
  imports = [
    ./common.nix
    ./zsh.nix
    ./zellij.nix
  ];

  home.shellAliases = {
    ls = "ls --color=auto";
    edit = "nvim ~/flake";
    clean = "sudo nh clean all --keep 3 && sudo nix-collect-garbage -d";
    switch = "${getExe pkgs.nh} ${cmd} switch ${flakeDir}";
    update = "${getExe pkgs.nh} ${cmd} switch ${flakeDir} -u";
    strip = "${getExe pkgs.exiftool} -all= -overwrite_original";
    open = mkIf (!pkgs.stdenv.isDarwin) "xdg-open";
    reboot = mkIf (!pkgs.stdenv.isDarwin) "systemctl reboot";
    nx = "nix-hash --type sha256 --to-sri";
  };
}
