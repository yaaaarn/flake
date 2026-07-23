{
  self,
  inputs,
  lib,
}:
let
  colors = import ../utils/colors.nix { inherit lib; };
  secrets = import "${self}/secrets/values.nix";

  mkSelfPrime = system: {
    packages = self.packages.${system} or { };
  };

  mkInputsPrime =
    system:
    lib.mapAttrs (
      _: input:
      lib.optionalAttrs (builtins.isAttrs input && input ? packages) {
        packages = input.packages.${system} or { };
      }
    ) inputs;

  mkSpecialArgs = system: class: {
    inherit
      lib
      self
      inputs
      colors
      class
      secrets
      ;
    self' = mkSelfPrime system;
    inputs' = mkInputsPrime system;
  };

  mkSystem =
    {
      builder,
      baseModules,
      class,
    }:
    system: hostName: extraModules:
    builder {
      inherit system;
      modules =
        baseModules
        ++ [
          ./home.nix
          ./${hostName}
          { networking.hostName = hostName; }
        ]
        ++ extraModules;
      specialArgs = mkSpecialArgs system class;
    };

  mkNixOS = mkSystem {
    builder = lib.nixosSystem;
    class = "nixos";
    baseModules = [
      "${self}/modules/base"
      "${self}/modules/nixos"
      inputs.preservation.nixosModules.default
      inputs.nix-index-database.nixosModules.default
      { system.configurationRevision = self.rev or self.dirtyRev or "unknown"; }
    ];
  };

  mkDarwin = mkSystem {
    builder = inputs.nix-darwin.lib.darwinSystem;
    class = "darwin";
    baseModules = [
      "${self}/modules/base"
      "${self}/modules/darwin"
      inputs.nix-index-database.darwinModules.nix-index
    ];
  };
in
{
  nixosConfigurations = {
    pocky = mkNixOS "x86_64-linux" "pocky" [
      inputs.nixos-hardware.nixosModules.apple-macbook-pro-11-5
      inputs.nixos-hardware.nixosModules.common-gpu-amd-southern-islands
      {
        unravelled = {
          profiles = {
            graphical.enable = true;
            laptop.enable = true;
            perf.mid.enable = true;
            full.enable = true;
          };
          apps = {
            wallpaper = "reisa-401361.jpg";
            desktops = {
              labwc.enable = true;
              niri.enable = true;
            };
            browsers = {
              firefox.enable = true;
              helium.enable = true;
            };
            editors.neovim.enable = true;
          };
        };
      }
    ];

    bento = mkNixOS "x86_64-linux" "bento" [
      {
        unravelled.profiles = {
          headless.enable = true;
          laptop.enable = true;
          perf.mid.enable = true;
          minimal.enable = true;
        };
      }
    ];

    mochi = mkNixOS "x86_64-linux" "mochi" [
      {
        unravelled = {
          profiles = {
            graphical.enable = true;
            desktop.enable = true;
            perf.high.enable = true;
            full.enable = true;
          };
          apps = {
            wallpaper = "IMG_5120-dithered.png";
            desktops = {
              labwc.enable = true;
              niri.enable = true;
            };
            browsers = {
              firefox.enable = true;
              helium.enable = true;
            };
            editors.neovim.enable = true;
          };
        };
      }
    ];

    sushi = mkNixOS "x86_64-linux" "sushi" [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
      {
        unravelled = {
          profiles = {
            graphical.enable = true;
            iso.enable = true;
            perf.low.enable = true;
            minimal.enable = true;
          };
          apps = {
            desktops = {
              labwc.enable = true;
              niri.enable = false;
            };
            browsers = {
              firefox.enable = true;
              helium.enable = true;
            };
            editors.neovim.enable = true;
          };
        };
      }
    ];
  };

  darwinConfigurations = {
    yarnball = mkDarwin "aarch64-darwin" "yarnball" [
      {
        unravelled.profiles = {
          headless.enable = true;
          server.enable = true;
          perf.high.enable = true;
          full.enable = true;
        };
      }
    ];
  };
}
