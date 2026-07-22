{
  description = "unravelled";
  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      lib = nixpkgs.lib;
      allPkgs = lib.genAttrs (import inputs.systems) (
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
          overlays = [ ];
        }
      );
    in
    {
      packages = import ./packages { inherit allPkgs inputs lib; };
    }
    // import ./hosts/default.nix { inherit self inputs lib; };

  inputs = {
    nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };

    preservation.url = "github:nix-community/preservation";

    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };

    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "git+https://github.com/nix-systems/default";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:port22exposed/nixpille-helium";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tsui = {
      url = "github:yaaaarn/tsui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nyaa = {
      url = "github:yaaaarn/nyaa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    downcloud = {
      url = "github:yaaaarn/downcloud";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.bun2nix.follows = "bun2nix";
    };
    osu-lazer-flake = {
      url = "github:yaaaarn/osu-lazer-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yarnfetch = {
      url = "github:yaaaarn/yarnfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tangle = {
      url = "github:yaaaarn/tangle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    banded = {
      url = "github:yaaaarn/banded";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tetro-tui = {
      url = "github:Strophox/tetro-tui";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-compat.follows = "flake-compat";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };
  };
}
