{
  pkgs,
  secrets,
  inputs,
  ...
}:
{
  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
      access-tokens = [
        "github.com=${secrets.githubAccessToken}"
      ];
    };

    optimise.automatic = true;
  };
}
