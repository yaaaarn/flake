{
  lib,
  pkgs,
  osConfig,
  config,
  secrets,
  ...
}:
let
  inherit (lib) mkDefault optionals;

  directory =
    if pkgs.stdenv.isDarwin then
      "${config.xdg.userDirs.documents}/Music"
    else
      config.xdg.userDirs.music;
in
{
  home.packages =
    with pkgs;
    optionals
      (osConfig.unravelled.profiles.graphical.enable && osConfig.unravelled.profiles.full.enable)
      [
        strawberry
        spek
      ];

  programs = {
    mpv = {
      enable = osConfig.unravelled.profiles.graphical.enable;
      package = pkgs.mpv.override { youtubeSupport = true; };
      scripts = [ pkgs.mpvScripts.uosc ];
      config = {
        profile = "high-quality";
        hwdec = "yes";
        # vo = "gpu-next";
        # gpu-api = "vulkan";

        ytdl-format = "bestvideo[height>=?1440][vcodec^=vp9]+bestaudio/bestvideo[height<=?1440][vcodec^=av0]+bestaudio/bestvideo+bestaudio/best";

        dscale = "catmull_rom";

        dither = "error-diffusion";
        dither-depth = "auto";
        error-diffusion = "sierra-lite";

        scale-antiring = 0.5;
        dscale-antiring = 0.5;
        cscale-antiring = 0.5;

        deband = "yes";
        deband-iterations = 4;
        deband-threshold = 35;
        deband-range = 16;
        deband-grain = 4;

        screenshot-format = "webp";
        screenshot-webp-lossless = "yes";
        screenshot-high-bit-depth = "yes";
        screenshot-sw = "no";
        screenshot-directory = config.xdg.userDirs.pictures;
        screenshot-template = "%f-%wH.%wM.%wS.%wT-#%#00n";
      };
    };

    beets = {
      enable = mkDefault osConfig.unravelled.profiles.full.enable;
      package = pkgs.python314Packages.beets.override {
        disableAllPlugins = true;
        pluginOverrides = {
          chroma.enable = true;
          musicbrainz.enable = true;
          convert.enable = true;
          fetchart.enable = true;
          substitute.enable = true;
          inline.enable = true;
          lyrics.enable = true;
        };
      };
      settings = {
        directory = directory;
        library = "${directory}/library.db";

        import = {
          move = true;
        };

        plugins = [
          "chroma"
          "musicbrainz"
          "convert"
          "fetchart"
          "substitute"
          "inline"
          "lyrics"
        ];

        musicbrainz = {
          genres = true;

          extra_tags = [
            "media"
            "year"
            "tracks"
            "catalognum"
            "barcode"
            "alias"
            "lavel"
            "country"
          ];

          external_ids = {
            bandcamp = true;
          };
        };

        convert = {
          never_convert_lossy_files = true;
        };

        chroma.auto = true;
        acoustid.apikey = secrets.acoustidApiKey;

        lyrics = {
          auto = false;
          force = true;
          sources = [ "lrclib" ];
          synced = true;
        };

        fetchart = {
          high_resolution = true;
          sources = [
            "filesystem"
            "coverart"
            "albumart"
          ];
        };

        paths = {
          default = "$albumartist/%substitute{$album}%aunique{}/$disc_and_track %substitute{$title}";
        };

        substitute = {
          "᲼" = "_";
        };

        item_fields = {
          disc_and_track = ''f"{disc:02d}.{track:02d}" if disctotal > 1 else f"{track:02d}"'';
        };

        aunique = {
          bracket = "()";
        };
      };
    };
  };
}
