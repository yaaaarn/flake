let
  bento = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINYpg8QbJUrz9irbWStjT0KnxX3tfpyui5I3S81CyKrI user@bento";
  mochi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKN65IuaUFQbxF4coTcGbD4Z/xjxZ8TNU1ZG2egr52bT user@mochi";
  pocky = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkccgQHBAAHsMlYcSlK827kkWZoZwRWIgXamRl70Vym user@pocky";
  yarnball = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB2nTKPHFqoc7vB+aK3Ik/9rR/2gAWjwSDnNEYIqGoJG user@yarnball";

  all = [
    bento
    mochi
    pocky
    yarnball
  ];
in
{

  "secrets/cloudflare-creds.age".publicKeys = all;
  "secrets/soju-password.age".publicKeys = all;
}
