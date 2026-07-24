{
  allPkgs,
  inputs,
  lib,
}:
lib.genAttrs (builtins.attrNames allPkgs) (
  system:
  let
    pkgs = allPkgs.${system};
    isLinux = pkgs.stdenv.isLinux;
  in
  lib.filterAttrs (_: v: v != null) {
    greybox = pkgs.callPackage ./greybox { };
    typetr-bitcount = pkgs.callPackage ./typetr-bitcount { };
    new-heterodox-mono = pkgs.callPackage ./new-heterodox-mono { };
    youtube-local = if isLinux then pkgs.callPackage ./youtube-local { } else null;
    parados = if isLinux then pkgs.callPackage ./parados { } else null;
    ratune = pkgs.callPackage ./ratune { };

    tetro-tui = inputs.tetro-tui.packages.${system}.default;
    helium = inputs.helium.packages.${system}.default;

    tsui = inputs.tsui.packages.${system}.default;
    yarnfetch = inputs.yarnfetch.packages.${system}.default;
    downcloud = inputs.downcloud.packages.${system}.default;
    nyaa = inputs.nyaa.packages.${system}.default;
    banded = inputs.banded.packages.${system}.default;
  }
)
