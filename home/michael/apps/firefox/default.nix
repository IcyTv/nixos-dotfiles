{ inputs, pkgs, lib, ... }:
let
  ycs = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon rec {
    pname = "ycs";
    version = "1.1.12";
    addonId = "{1f09eef6-bc49-4f11-b4f2-da2705b2f8b4}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4013533/ycs-${version}.xpi";
    sha256 = "sha256-q2NfeC1Cc7syvM5nANyrz0ac0cr6Rv/9+nGon/Ttg/s=";

    meta = { };
  };
  pinned-gmail = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon rec {
    pname = "pinned-gmail";
    version = "2.4.0";
    addonId = "gmail_panel@alejandrobrizuela.com.ar";
    url = "https://addons.mozilla.org/firefox/downloads/file/4132394/pinned_gmail-${version}.xpi";
    sha256 = "sha256-sHdqCfSHc8SR5iigbAqpfSjfxqSAJ9BkGsfFelHrhcs=";

    meta = { };
  };

  shared-extensions = with pkgs.nur.repos.rycee.firefox-addons;
    [
      ublock-origin
      privacy-badger
      decentraleyes
      translate-web-pages
      i-dont-care-about-cookies
    ];

  # TODO gemini for google & optisearch

  sharedSettings = {
    # disable Studies
    # disable Normandy/Shield [FF60+]
    # Shield is a telemetry system that can push and test "recipes"
    "app.normandy.api_url" = "";
    "app.normandy.enabled" = false;

    # personalized Extension Recommendations in about:addons and AMO [FF65+]
    # https://support.mozilla.org/kb/personalized-extension-recommendations 
    "browser.discovery.enabled" = false;
    "browser.helperApps.deleteTempFileOnExit" = true;

    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.newtabpage.activity-stream.feeds.topsites" = true;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.uitour.enabled" = false;

    "geo.provider.use_gpsd" = false;
    "geo.provider.use_geoclue" = false;

    # HIDDEN PREF: disable recommendation pane in about:addons (uses Google Analytics)
    "extensions.getAddons.showPane" = false;
    # recommendations in about:addons' Extensions and Themes panes [FF68+]
    "extensions.htmlaboutaddons.recommendations.enabled" = false;


    "browser.aboutConfig.showWarning" = false;
    "browser.bookmarks.addedImportButton" = false;
    # extensions.activeThemeID
    "layout.css.prefers-color-scheme.content-override" = "dark";
    # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;

    # disable updates (pretty pointless with nix)
    "app.update.channel" = "default";

    "browser.download.viewableInternally.typeWasRegistered.svg" = true;
    "browser.download.viewableInternally.typeWasRegistered.webp" = true;
    "browser.download.viewableInternally.typeWasRegistered.xml" = true;

    "browser.search.region" = "DE";

    "browser.shell.checkDefaultBrowser" = false;

    "browser.tabs.loadInBackground" = true;

    "browser.urlbar.quickactions.enabled" = false;
    "browser.urlbar.quickactions.showPrefs" = false;
    "extensions.webcompat.perform_ua_overrides" = true;

    "print.print_footerleft" = "";
    "print.print_footerright" = "";
    "print.print_headerleft" = "";
    "print.print_headerright" = "";

    "privacy.donottrackheader.enabled" = true;

    # Yubikey
    "security.webauth.u2f" = true;
    "security.webauth.webauthn" = true;
    "security.webauth.webauthn_enable_softtoken" = true;
    "security.webauth.webauthn_enable_usbtoken" = true;
  };

in
{
  home.packages = with pkgs; [
    (makeDesktopItem {
      name = "firefox-yes";
      desktopName = "Firefox (Yes)";
      icon = "${pkgs.firefox}/share/icons/hicolor/128x128/apps/firefox.png";
      exec = "${pkgs.firefox}/bin/firefox -p Yes";
    })
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    policies = {
      CaptivePortal = false;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisplayBookmarksToolbar = "always";
      DisplayMenuBar = "default-off";
      DisableProfileImport = true;
      OfferToSaveLogins = false; # Because we have bitwarden

      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
        WhatsNew = false;
        MoreFromFirefox = false;
      };
      NoDefaultBookmarks = false;
      DontCheckDefaultBrowser = true;
      DisableSystemAddonUpdate = true;
      ExtensionUpdate = false;

      DisableFeedbackCommands = true;
      SearchEngines.Default = "Google";
    };

    profiles = {
      nixos = {
        id = 0;
        name = "NixOS";
        isDefault = true;

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          privacy-badger
          bypass-paywalls-clean
          bitwarden
          duckduckgo-privacy-essentials
          flagfox
          languagetool
          onetab
          return-youtube-dislikes
          scroll_anywhere
          sponsorblock
          tabliss
          translate-web-pages
          unpaywall
          playback-speed
          web-archives
          rust-search-extension
          wikiwand-wikipedia-modernized
          buster-captcha-solver
          decentraleyes
          link-cleaner
          i-dont-care-about-cookies

          ycs
          pinned-gmail
        ];

        settings = sharedSettings;

        search.engines = {
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "My NixOS" = {
            urls = [{ template = "https://mynixos.com/search?q={searchTerms}"; }];
            iconUpdateUrl = "https://mynixos.com/favicon-32x32.png";
            updateInterval = 24 * 60 * 60 * 1000 * 30; # every month
            definedAliases = [ "@nix" "@opts" ];
          };

          "Bing".metaData.hidden = true;
          "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
      };

      yes = {
        id = 1;
        name = "Yes";

        extensions = shared-extensions;

        settings = sharedSettings;
      };
    };
  };


  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["firefox.desktop"];
      "video/mp4" = ["mpv.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "text/html" = ["firefox.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["firefox.desktop"];
      "application/x-extension-htm" = ["firefox.desktop"];
      "application/x-extension-html" = ["firefox.desktop"];
      "application/x-extension-shtml" = ["firefox.desktop"];
      "application/x-extension-xht" = ["firefox.desktop"];
      "application/x-extension-xhtml" = ["firefox.desktop"];
      "application/x-www-browser" = ["firefox.desktop"];
      "application/xhtml+xml" = ["firefox.desktop"];
      "text/html" = ["firefox.desktop"];
      "x-scheme-handler/chrome" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/ftp" = ["firefox.desktop"];
      "x-scheme-handler/about" = ["firefox.desktop"];
      "x-scheme-handler/unknown" = ["firefox.desktop"];
      "x-scheme-handler/webcal" = ["firefox.desktop"];
      "x-www-browser" = ["firefox.desktop"];
    };
  };
}
