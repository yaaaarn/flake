{
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf osConfig.unravelled.profiles.graphical.enable {
    home.packages = with pkgs; [
      concord-tui
    ];

    services.arrpc.enable = pkgs.stdenv.isLinux;

    programs.equibop = {
      enable = true;

      settings = {
        frameless = true;
        appBadge = true;
        arRPC = false;
        checkUpdates = false;
        hardwareAcceleration = true;
        staticTitle = true;
      };

      equicord = {
        settings = {
          plugins = {
            MessageLogger = {
              enabled = true;
              ignoreSelf = true;
            };
            AnonymiseFileNames = {
              enabled = true;
            };
            ImageZoom = {
              enabled = true;
              square = true;
              zoom = 2.0;
              size = 250.0;
            };
            FakeNitro = {
              enabled = true;
            };
            ClearURLs.enabled = true;
            ServerInfo = {
              enabled = true;
            };
            YoutubeAdblock.enabled = true;
            FixYoutubeEmbeds.enabled = true;
            MessageLatency.enabled = true;
            DontRoundMyTimestamps.enabled = true;
            GoogleThat = {
              enabled = true;
              hyperlink = true;
              defaultEngine = "DuckDuckGo";
            };
            PlatformSpoofer = {
              enabled = true;
              platform = "desktop";
            };
            DisableCameras = {
              enabled = true;
            };
            BetterForwards = {
              enabled = true;
            };
          };
        };
      };
    };

  };
}
