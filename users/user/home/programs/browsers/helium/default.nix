{
  inputs,
  self',
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  inherit (lib)
    mkIf
    ;

  heliumPolicyDir = pkgs.writeTextDir "policies/managed/helium.json" (
    builtins.toJSON {
      ExtensionInstallForcelist = map (id: "${id};https://services.helium.imput.net/ext") [
        # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
        "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock
        "jinjaccalgkegednnccohejagnlnfdag" # violentmonkey
        "lckanjgmijmafbedllaakclkaicjfmnk" # clearurls
        "hlkenndednhfkekhgcdicdfddnkalmdm" # cookie-editor
      ];
      ClearBrowsingDataOnExitList = [
        "browsing_history"
        "download_history"
        # "cookies_and_other_site_data" # because of CookiesSessionOnlyForUrls
        "cached_images_and_files"
        "password_signin"
        "autofill"
        "site_settings"
        "hosted_app_data"
      ];
      RestoreOnStartup = 5;
      CacheEncryptionEnabled = true;

      BookmarkBarEnabled = true;
      ManagedBookmarks = import ../bookmarks.nix;

      DefaultCookiesSetting = 1;
      CookiesSessionOnlyForUrls = [ "*://*/*" ];
      CookiesAllowedForUrls = import ../allowedUrls.nix;

      SearchSuggestEnabled = false;

      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderKeyword = "4get";
      DefaultSearchProviderName = "4get";
      NewTabPageLocation = "https://dash.yarncat.moe";
      HomePageIsNewTab = true;
      DefaultSearchProviderSearchURL = "https://search.yarncat.moe/web?s={searchTerms}";

      SafeSitesFilterBehavior = 0;

      ClearCrossSiteCrossBrowsingContextGroupWindowName = true;

      DefaultNotificationsSetting = 2;
      NotificationsAllowedForUrls = [
        "https://discord.com"
        "https://mail.proton.me"
      ];

      DefaultGeolocationSetting = 2;

      # ai slop
      AimEnabled = false;
      AIModeSettings = 1;
      AutofillPredictionSettings = 2;
      AutomatedPasswordChangeSettings = 2;
      BuiltInAIAPIsEnabled = 2;
      ChromeSuggestionsSettings = 1;
      CreateThemesSettings = 2;
      DevToolsGenAiSettings = 2;
      GeminiSettings = 1;
      GeminiSparkSettings = 1;
      GeminiActOnWebSettings = 1;
      GenAILocalFoundationalModelSettings = 1;
      GoogleSearchSidePanelEnabled = false;
      HelpMeWriteSettings = 2;
      HistorySearchSettings = 2;
      LensStandalone = false;
      SearchContentSharingSettings = 1;
      StarterPackExpansion = false;
      TabCompareSettings = 2;
      TranslatorAPIAllowed = false;

      # idek
      ClickToCallEnabled = false;
      SharedClipboardEnabled = false;
      ShoppingListEnabled = false;

      # journey bullshit
      Journeys = false;
      HistoryClustersVisible = false;

      # webrtc
      WebRtcIPHandling = "disable_non_proxied_udp";
      WebRtcTextLogCollectionAllowed = false;

      # download prompt
      PromptForDownloadLocation = true;

      ShowFullUrlsInAddressBar = true;

      SitePerProcess = true;

      LocalNetworkAccessChecksWebRTC = true;
    }
  );

  heliumWrapped = pkgs.symlinkJoin {
    name = "helium-wrapped";
    paths = [
      self'.packages.helium
    ];
    nativeBuildInputs = [
      pkgs.makeWrapper
    ];
    postBuild = ''
      wrapProgram $out/bin/helium \
        --run 'exec ${lib.getExe pkgs.bubblewrap} \
          --dev-bind / / \
          --bind ${heliumPolicyDir} /etc/chromium \
          ${self'.packages.helium}/bin/helium "$@"'
    '';
  };
in
{
  imports = [ inputs.helium.homeModules.default ];

  config = mkIf osConfig.unravelled.options.browsers.helium.enable {
    programs.helium = {
      enable = mkIf (!(pkgs.stdenv.isDarwin)) true;

      commandLineArgs = [
        "--disable-geolocation"
        "--metrics-recording-only"
        "--disable-battery-status-api"
        "--disable-idn-navigation-suggestions"
        "--force-prefers-reduced-motion"
        "--no-default-browser-check"
        "--helium-noise-canvas"
        "--disable-wake-on-wifi"
        "--disable-sync"
        "--gtk-version=4"
        "--helium-noise-audio"
        "--helium-noise-hw-concurrency"
        "--no-pings"
        "--component-updater=require_encryption"
        "--no-crash-upload"
        "--no-service-autorun"
        "--no-first-run"
        "--disable-breakpad"
        "--ignore-gpu-blocklist"

        (
          "--enable-features="
          + lib.concatMapStrings (x: x + ",") [
            # Enable visited link database partitioning
            "PartitionVisitedLinkDatabase"

            # Enable prefetch privacy changes
            "PrefetchPrivacyChanges"

            # Enable split cache
            "SplitCacheByNetworkIsolationKey"
            "SplitCodeCacheByNetworkIsolationKey"

            # Enable partitioning connections
            "EnableCrossSiteFlagNetworkIsolationKey"
            "HttpCacheKeyingExperimentControlGroup"
            "PartitionConnectionsByNetworkIsolationKey"

            # Enable strict origin isolation
            "StrictOriginIsolation"

            # Enable reduce accept language header
            "ReduceAcceptLanguage"

            # Enable content settings partitioning
            "ContentSettingsPartitioning"
          ]
        )
        (
          "--disable-features="
          + lib.concatMapStrings (x: x + ",") [
            # Disable autofill
            "AutofillPaymentCardBenefits"
            "AutofillPaymentCvcStorage"
            "AutofillPaymentCardBenefits"

            # Disable third-party cookie deprecation bypasses
            "TpcdHeuristicsGrants"
            "TpcdMetadataGrants"

            # Disable hyperlink auditing
            "EnableHyperlinkAuditing"

            # Disable showing popular sites
            "NTPPopularSitesBakedInContent"
            "UsePopularSitesSuggestions"

            # Disable article suggestions
            "EnableSnippets"
            "ArticlesListVisible"
            "EnableSnippetsByDse"

            # Disable content feed suggestions
            "InterestFeedV2"

            # Disable media DRM preprovisioning
            "MediaDrmPreprovisioning"

            # Disable autofill server communication
            "AutofillServerCommunication"

            # Disable new privacy sandbox features
            "PrivacySandboxSettings4"
            "BrowsingTopics"
            "BrowsingTopicsDocumentAPI"
            "BrowsingTopicsParameters"

            # Disable translate button
            "AdaptiveButtonInTopToolbarTranslate"

            # Disable detailed language settings
            "DetailedLanguageSettings"

            # Disable fetching optimization guides
            "OptimizationHintsFetching"

            # Partition third-party storage
            "DisableThirdPartyStoragePartitioningDeprecationTrial2"

            # Disable media engagement
            "PreloadMediaEngagementData"
            "MediaEngagementBypassAutoplayPolicies"

            # allow manifest v2
            "ExtensionManifestV2Unsupported"
            "ExtensionManifestV2Disabled"
          ]
        )
      ];

      package = heliumWrapped;
      dictionaries = with pkgs.hunspellDictsChromium; [ en_US ];
    };

  };
}
