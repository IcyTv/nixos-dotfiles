{ pkgs, lib, ... }:
let
  ycs = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon {
    pname = "ycs";
    version = "1.1.12";
    addonId = "{1f09eef6-bc49-4f11-b4f2-da2705b2f8b4}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4013533/ycs-1.1.12.xpi";
    sha256 = "sha256-q2NfeC1Cc7syvM5nANyrz0ac0cr6Rv/9+nGon/Ttg/s=";

    meta = {};
  };
  pinned-gmail = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon {
    pname = "pinned-gmail";
    version = "2.4.0";
    addonId = "gmail_panel@alejandrobrizuela.com.ar";
    url = "https://addons.mozilla.org/firefox/downloads/file/4132394/pinned_gmail-2.4.0.xpi";
    sha256 = "sha256-sHdqCfSHc8SR5iigbAqpfSjfxqSAJ9BkGsfFelHrhcs=";

    meta = {};
  };
in {
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

          ycs
          pinned-gmail
        ];
      };
    };
  };
}
