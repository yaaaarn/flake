{
  allPkgs,
  inputs,
  lib,
}:
lib.genAttrs (builtins.attrNames allPkgs) (
  system:
  let
    pkgs = allPkgs.${system};
  in
  {
    greybox = pkgs.callPackage ./greybox { };
    typetr-bitcount = pkgs.callPackage ./typetr-bitcount { };
    new-heterodox-mono = pkgs.callPackage ./new-heterodox-mono { };
    youtube-local = pkgs.callPackage ./youtube-local { };
    parados = pkgs.callPackage ./parados { };

    tetro-tui = inputs.tetro-tui.packages.${system}.default;
    helium = inputs.helium.packages.${system}.default;

    tsui = inputs.tsui.packages.${system}.default;
    yarnfetch = inputs.yarnfetch.packages.${system}.default;
    downcloud = inputs.downcloud.packages.${system}.default;
    nyaa = inputs.nyaa.packages.${system}.default;
    banded = inputs.banded.packages.${system}.default;
  }
)
