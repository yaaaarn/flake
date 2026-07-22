{
  pkgs,
  config,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git
    fd
    tree
    nmap
    nh
    fastfetch
    exiftool
    nix-tree
    fzf
    just
    nix-prefetch-git
    gh
    jq
    git-crypt
  ];

  users.users.${config.unravelled.system.mainUser}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYpg8QbJUrz9irbWStjT0KnxX3tfpyui5I3S81CyKrI user@dango"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKN65IuaUFQbxF4coTcGbD4Z/xjxZ8TNU1ZG2egr52bT user@mochi"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkccgQHBAAHsMlYcSlK827kkWZoZwRWIgXamRl70Vym user@pocky"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB2nTKPHFqoc7vB+aK3Ik/9rR/2gAWjwSDnNEYIqGoJG user@yarnball"
  ];

  programs.nix-index-database = {
    comma.enable = true;
  };

  documentation = {
    enable = true;
    man.enable = true;
    doc.enable = false;
  };
}
