{
  config,
  lib,
  pkgs,
  self',
  ...
}:
let
  inherit (lib) mkEnableOption mkOption mkIf optional;
  inherit (lib.types) types;
  cfg = config.services.youtube-local;
  youtube-local-pkg = self'.packages.youtube-local;
in
{
  options.services.youtube-local = {
    enable = mkEnableOption "youtube-local service";

    package = mkOption {
      type = types.package;
      default = youtube-local-pkg;
      description = "The youtube-local package to use.";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "The port the server will listen on.";
    };

    # Network / Tor Settings
    routeTor = mkOption {
      type = types.ints.between 0 2;
      default = 1; # 0 = Off, 1 = On except video, 2 = On including video
      description = "Tor routing mode.";
    };

    torPort = mkOption {
      type = types.port;
      default = 9150;
      description = "SOCKS port used by Tor backend.";
    };

    torControlPort = mkOption {
      type = types.port;
      default = 9151;
      description = "Control port used by Tor backend.";
    };

    proxyImages = mkOption {
      type = types.bool;
      default = true;
      description = "Route image requests through the proxy.";
    };

    allowForeignAddresses = mkOption {
      type = types.bool;
      default = false;
      description = "Allow remote IP connections to the server instance.";
    };

    allowForeignPostRequests = mkOption {
      type = types.bool;
      default = false;
      description = "Allow POST requests from outside network addresses.";
    };

    # Playback Settings
    defaultResolution = mkOption {
      type = types.enum [
        144
        240
        360
        480
        720
        1080
        1440
        2160
      ];
      default = 720;
      description = "Default streaming video quality resolution.";
    };

    autoplayVideos = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically play videos on load.";
    };

    defaultVolume = mkOption {
      type = types.ints.between (-1) 100;
      default = -1; # -1 lets browser handle volume
      description = "Forced default player volume (-1 to 100).";
    };

    subtitlesMode = mkOption {
      type = types.ints.between 0 2;
      default = 0; # 0 = off, 1 = manual only, 2 = automatic fallback
      description = "Caption track delivery preference behavior.";
    };

    subtitlesLanguage = mkOption {
      type = types.str;
      default = "en";
      description = "ISO 639 target language format selection code.";
    };

    useSponsorblockJs = mkOption {
      type = types.bool;
      default = false;
      description = "Enable native client-side SponsorBlock skipping hooks.";
    };

    preferUniSources = mkOption {
      type = types.ints.between 0 2;
      default = 1; # 0 = Prefer not, 1 = Prefer, 2 = Always
      description = "Prefer unified file sources over distinct AV streams.";
    };

    # Codec Rankings
    codecRankH264 = mkOption {
      type = types.ints.between 1 3;
      default = 1;
      description = "Priority ranking for the H.264 video container format.";
    };

    codecRankVp = mkOption {
      type = types.ints.between 1 3;
      default = 2;
      description = "Priority ranking for the VP8/VP9 web open format.";
    };

    codecRankAv1 = mkOption {
      type = types.ints.between 1 3;
      default = 3;
      description = "Priority ranking for the high-efficiency AV1 streaming format.";
    };

    # Interface Settings
    theme = mkOption {
      type = types.ints.between 0 2;
      default = 0; # 0 = Light, 1 = Gray, 2 = Dark
      description = "Color layout appearance framework selection index.";
    };

    font = mkOption {
      type = types.ints.between 0 4;
      default = 1; # 0 = Browser, 1 = Arial, 2 = LibSerif, 3 = Verdana, 4 = Tahoma
      description = "Primary typography choice identifier.";
    };

    theaterMode = mkOption {
      type = types.bool;
      default = true;
      description = "Default stream interface canvas expansion scale.";
    };

    videoPlayer = mkOption {
      type = types.ints.between 0 1;
      default = 1; # 0 = Browser Default, 1 = Plyr engine overlay
      description = "Target player playback core library instance target.";
    };

    useVideoHotkeys = mkOption {
      type = types.bool;
      default = true;
      description = "Process macro controls layout event interception commands.";
    };

    relatedVideosMode = mkOption {
      type = types.ints.between 0 2;
      default = 1; # 0 = Disabled, 1 = Always, 2 = Click-to-Show
      description = "Recommendation panel presentation target index mapping.";
    };

    commentsMode = mkOption {
      type = types.ints.between 0 2;
      default = 1; # 0 = Disabled, 1 = Always, 2 = Click-to-Show
      description = "Discussion string panel behavior target presentation map index.";
    };

    defaultCommentSorting = mkOption {
      type = types.ints.between 0 1;
      default = 0; # 0 = Top, 1 = Newest
      description = "Sorting criteria configuration for user threads feed.";
    };

    enableCommentAvatars = mkOption {
      type = types.bool;
      default = true;
      description = "Query and display asset icons within layout threads.";
    };

    useCommentsJs = mkOption {
      type = types.bool;
      default = true;
      description = "Process script-based parsing loops for comment payloads.";
    };

    embedPageMode = mkOption {
      type = types.bool;
      default = true;
      description = "Activate functional fallback targets for framed inline wrappers.";
    };

    # Subscriptions & Testing
    autocheckSubscriptions = mkOption {
      type = types.bool;
      default = false;
      description = "Periodically background poll channel manifest states.";
    };

    includeShortsInSubscriptions = mkOption {
      type = types.bool;
      default = false;
      description = "Filter fast short format assets inside aggregate lists.";
    };

    includeShortsInChannel = mkOption {
      type = types.bool;
      default = true;
      description = "Expose short timeline index streams on specific profiles.";
    };

    debuggingSaveResponses = mkOption {
      type = types.bool;
      default = false;
      description = "Dump active raw structures into cache logs.";
    };
  };
  config = mkIf cfg.enable {
    # Tor routing automation if configured or explicitly active
    services.tor = mkIf (cfg.routeTor > 0) {
      enable = true;
      client.enable = true;
      settings.SocksPort = [
        9050
        cfg.torPort
      ];
    };

    systemd.services.youtube-local =
      let
        # Convert Nix booleans into lowercase strings expected by youtube-local's parser
        boolToStr = b: if b then "True" else "False";

        flatSettingsFile = pkgs.writeText "settings.txt" (
          lib.generators.toKeyValue { } {
            route_tor = cfg.routeTor;
            tor_port = cfg.torPort;
            tor_control_port = cfg.torControlPort;
            port_number = cfg.port;
            allow_foreign_addresses = boolToStr cfg.allowForeignAddresses;
            allow_foreign_post_requests = boolToStr cfg.allowForeignPostRequests;
            subtitles_mode = cfg.subtitlesMode;
            subtitles_language = cfg.subtitlesLanguage;
            default_volume = cfg.defaultVolume;
            related_videos_mode = cfg.relatedVideosMode;
            comments_mode = cfg.commentsMode;
            enable_comment_avatars = boolToStr cfg.enableCommentAvatars;
            default_comment_sorting = cfg.defaultCommentSorting;
            theater_mode = boolToStr cfg.theaterMode;
            default_resolution = cfg.defaultResolution;
            autoplay_videos = boolToStr cfg.autoplayVideos;
            codec_rank_h264 = cfg.codecRankH264;
            codec_rank_vp = cfg.codecRankVp;
            codec_rank_av1 = cfg.codecRankAv1;
            prefer_uni_sources = cfg.preferUniSources;
            use_video_hotkeys = boolToStr cfg.useVideoHotkeys;
            video_player = cfg.videoPlayer;
            proxy_images = boolToStr cfg.proxyImages;
            use_comments_js = boolToStr cfg.useCommentsJs;
            use_sponsorblock_js = boolToStr cfg.useSponsorblockJs;
            theme = cfg.theme;
            font = cfg.font;
            embed_page_mode = boolToStr cfg.embedPageMode;
            autocheck_subscriptions = boolToStr cfg.autocheckSubscriptions;
            include_shorts_in_subscriptions = boolToStr cfg.includeShortsInSubscriptions;
            include_shorts_in_channel = boolToStr cfg.includeShortsInChannel;
            debugging_save_responses = boolToStr cfg.debuggingSaveResponses;
            settings_version = 6;
          }
        );

      in
      {
        description = "youtube-local: Browser-based anonymous YouTube client";
        after = [ "network.target" ] ++ optional (cfg.routeTor > 0) "tor.service";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          StateDirectory = "youtube-local";
          WorkingDirectory = "/var/lib/youtube-local";
          Environment = "HOME=/var/lib/youtube-local";

          ExecStartPre = pkgs.writeShellScript "youtube-local-cfg" ''
            rm -f /var/lib/youtube-local/settings.txt
            cp ${flatSettingsFile} /var/lib/youtube-local/settings.txt
            chmod 600 /var/lib/youtube-local/settings.txt
          '';

          ExecStart = "${cfg.package}/bin/youtube-local";

          Restart = "on-failure";
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          ReadWritePaths = [ "/var/lib/youtube-local" ];
        };
      };
  };
}
