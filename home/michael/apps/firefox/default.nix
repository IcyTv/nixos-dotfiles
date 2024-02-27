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
      DisableProfileImport = true;

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

        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.bookmarks.addedImportButton" = false;
          # extensions.activeThemeID
          "layout.css.prefers-color-scheme.content-override" = "dark";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
        };

        userChrome = ''
        /* This will be updated more in the future */

:root {
  --red: #f38ba8;
  --peach: #fab387;
  --yellow: #f9e2af;
  --green: #a6e3a1;
  --teal: #94e2d5;
  --blue: #89b4fa;
  --lavender: #b4befe;
  --text: #cdd6f4;
  --subtext1: #bac2de;
  --subtext0: #a6adc8;
  --overlay2: #9399b2;
  --surface2: #585b70;
  --surface1: #45475a;
  --surface0: #313244;
  --base: #1e1e2e;
  --mantle: #181825;
  --crust: #11111b;
  
  --toolbar-field-background-color: var(--surface0)!important; /* To change the colour of the url bar */
  --toolbar-color: var(--text) !important;
  
  --toolbarbutton-border-radius: 20px !important; /* Rounded toolbar buttons */
  --tab-border-radius: 500px !important; /* Making rounded new tab button */
  --toolbarbutton-icon-fill: var(--text) !important; /* Changing the colour of icons */
}


/* Change the title bar colour */
#titlebar {
  background-color: var(--mantle)!important;
}

/* Rounded tabs*/
.tab-background {
  border-radius: 500px !important;
}

/* background colour of active tab */
.tab-background[selected]{
  background-image: none !important;
  background-color: var(--green) !important;
}

/* Updates the text of the active tab */
.tab-label-container[selected] {
  color: var(--crust) !important;
}

/* Changes the colour of the close button */
.tab-close-button.close-icon[selected] {
  color: var(--crust) !important; 
}

/* For Title bar colours */
.browser-toolbar {
  &:not(.titlebar-color) {
    background-color: var(--mantle) !important;
    color: var(--text);
  }
}

@media only screen and (max-width: 1432px){
  #search-container {
    display: none !important;
  }
}

#urlbar[focused="true"]:not([suppress-focus-border]) > #urlbar-background,
#searchbar:focus-within {
  --toolbar-field-focus-border-color: var(--blue); /* To make the searchbar outline catppuccin blue */
}

/* To change the color of the url bar */ 
#urlbar-background, #searchbar {
  background-color: var(--surface0) !important;
}

/* Hide the search bars buddon */
#alltabs-button {
  display: none;
}

/* Changing the urlbar text clour */
#urlbar-input, #urlbar-scheme, .searchbar-textbox {
  color: var(--text) !important;
}

/* Chaning the colour of the search icon */
#urlbar, #searchbar {
  color: var(--text) !important;
}

/* Changing the colour of the unused tabs */
#navigator-toolbox {
  &:-moz-lwtheme {
    color: var(--subtext0) !important;
  }
}


/* To change the ctrl-F bar */
findbar {
  background: var(--mantle) !important;
  background-position-y: 0%;
}

.checkbox-check {
  border-radius: 500px !important;;
}

.findbar-textbox {
  border-radius: 500px !important;
}

.checkbox-check[checked] {
  background-color: var(--green) !important;
  fill: var(--mantle) !important;
}

.close-icon, .findbar-find-previous, .findbar-find-next {
  border-radius: 500px !important;
}'';
      };

      yes = {
        id = 1;
        name = "Yes";

        extensions = shared-extensions;
      };
    };
  };
}
