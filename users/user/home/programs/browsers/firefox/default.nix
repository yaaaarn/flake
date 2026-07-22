{
  lib,
  pkgs,
  osConfig,
  colors,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;

  extensions = with inputs.nur.legacyPackages.${pkgs.stdenv.system}.repos.rycee.firefox-addons; [
    ublock-origin
    bitwarden
    sponsorblock
    (buildFirefoxXpiAddon {
      pname = "clearurls";
      version = "1.27.3";
      addonId = "{63cc54e3-27ba-4afe-9c93-29e6661f8707}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4432106/clearurls-1.27.3.xpi";
      sha256 = "sha256-VJJrbkJ01ZNaX8DapjIPHTcePS8aWHdGfKOrIqZcTyA=";
      meta = with lib; {
        homepage = "https://clearurls.xyz";
        description = "Removes tracking elements from URLs";
        license = licenses.gpl3Only;
        mozPermissions = [
          "downloads"
          "tabs"
          "webNavigation"
          "<all_urls>"
        ];
        platforms = platforms.all;
      };
    })
    privacy-badger
    violentmonkey
    cookie-editor
  ];

  browserConfig = {
    # ui
    "browser.aboutConfig.showWarning" = false; # disabled because i'm cool
    "devtools.toolbox.host" = "right";
    "browser.toolbars.bookmarks.visibility" = "always";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "browser.uidensity" = 1;
    # "ui.prefersReducedMotion" = 1;
    "widget.gtk.libadwaita-colors.enabled" = false;
    "browser.tabs.inTitlebar" = 0;

    # performance
    "gfx.webrender.all" = true;
    "browser.tabs.unloadOnLowMemory" = true;

    # peace of mind
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.system.showSponsored" = false;
    "extensions.getAddons.showPane" = false;

    # opsec
    "network.IDN_show_punycode" = true; # no more unicode bs

    "browser.urlbar.suggest.engines" = false; # disables tab to search
    "browser.urlbar.suggest.quicksuggest.sponsored" = false; # we fucking hate ads
    "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = ""; # i forgor
    "geo.enabled" = false; # disable geolocation
    "browser.search.region" = "US";

    "browser.contentblocking.category" = {
      Value = "Strict";
      Status = "Locked";
    };
    "dom.battery.enabled" = false;

    # idek lol
    "dom.private-attribution.submission.enabled" = false;

    "extensions.autoDisableScopes" = 0;

    "media.eme.enabled" = true; # activates drm
    "media.peerconnection.enabled" = false; # disable webrtc to avoid ip leaks

    # qol
    "dom.events.testing.asyncClipboard" = true;
  };

  policies = {
    # piss off
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableProfileImport = true;
    DisableFirefoxAccounts = true;
    DontCheckDefaultBrowser = true;
    BackgroundAppUpdate = false;
    NoDefaultBookmarks = true;
    FirefoxSuggest = {
      WebSuggestions = false;
      Locked = true;
    };
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";

    # needed for bitwarden
    OfferToSaveLogins = false;
    PasswordManagerEnabled = false;

    # https only
    HttpAllowlist = [
      "https://yarnball.char-ruler.ts.net"
    ];
    HttpsOnlyMode = "force_enabled";

    SearchSuggestEnabled = false;

    ### perf
    HardwareAcceleration = true;

    GenerativeAI = {
      Chatbot = false;
      SmartWindow = false;
      LinkPreviews = false;
      TabGroups = true;
      Enabled = false;
    };

    ### ui
    DisplayMenuBar = "default-off";

    NewTabPage = false;
    FirefoxHome = {
      Search = false;
      TopSites = false;
      Highlights = false;
      Pocket = false;
      Snippets = false;
    };

    ### opsec
    Cookies = {
      Allow = import ../allowedUrls.nix;
      Behavior = "reject-tracker";
      Locked = true;
    };

    EnableTrackingProtection = {
      Category = "strict";
      Locked = true;
      BaselineExceptions = false;
      ConvenienceExceptions = false;
    };

    SanitizeOnShutdown = {
      Cache = true;
      Cookies = true;
      FormData = true;
      History = true;
      Sessions = true;
    };

    ### branding i guess
    SearchEngines = {
      Add = [
        {
          Name = "4get";
          URLTemplate = "https://search.yarncat.moe/web?s={searchTerms}";
        }
      ];
      Default = "4get";
      DefaultPrivate = "4get";
      PreventInstalls = true;
    };

    ShowHomeButton = true;
    Homepage = {
      URL = "https://dash.yarncat.moe";
      Locked = true;
    };

    ManagedBookmarks = import ../bookmarks.nix;

    Preferences = browserConfig;
  };
in
{
  config = mkIf osConfig.unravelled.options.browsers.firefox.enable {
    programs.firefox = {
      enable = true;

      policies = policies;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        extensions.packages = extensions;

        userChrome = ''
          :root {
            --toolbar-bgcolor: #${colors.background} !important;
            --lwt-accent-color: #${colors.background} !important;
            --tab-selected-bgcolor: #${colors.background} !important;
            --lwt-text-color: #${colors.foreground} !important;
            --toolbar-color: #${colors.foreground} !important;
          }
          #navigator-toolbox {
            background-color: #${colors.background} !important;
            color: #${colors.foreground} !important;
            border-bottom: none !important;
          }
        '';

        userContent = ''
          @-moz-document url(about:blank), url(about:newtab), url(about:home) {
            body {
              background-color: #${colors.background} !important;
              color: #${colors.foreground} !important;
            }
          }
        '';
      };
    };
  };
}
