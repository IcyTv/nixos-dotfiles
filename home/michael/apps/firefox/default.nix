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
      profile-switcher
      decentraleyes
      translate-web-pages
    ];

  # TODO gemini for google & optisearch

in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [
        (pkgs.callPackage ./profile-switcher.nix { })
      ];
    };

    policies = {
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

      # ExtensionSettings = {
      #   "gmail_panel@alejandrobrizuela.com.ar" = {
      #     installation_mode = "normal_installed";
      #     install_url = "https://addons.mozilla.org/firefox/downloads/file/4132394/pinned_gmail-2.4.0.xpi";
      #   };
      #   "{1f09eef6-bc49-4f11-b4f2-da2705b2f8b4}" = {
      #     installation_mode = "force_installed";
      #     install_url = "https://addons.mozilla.org/firefox/downloads/file/4013533/ycs-1.1.12.xpi";
      #   };
      # };
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
          profile-switcher
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

          ycs
          pinned-gmail
        ];
      };

      yes = {
        id = 1;
        name = "Yes";

        extensions = shared-extensions;
      };
    };
  };
}
