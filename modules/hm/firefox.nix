_:
let
  enabled = {
    Value = true;
  };
  disabled = {
    Value = false;
  };
  enabledLocked = enabled // {
    Locked = true;
  };
  disabledLocked = disabled // {
    Locked = true;
  };
in
{
  config = {
    programs.firefox = {
      enable = true;
      # nativeMessagingHosts = [  ];
      policies = {
        DisplayBookmarksToolbar = "always";
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = enabled // {
          Cryptomining = true;
          Fingerprinting = true;
        };
        FirefoxHome = {
          Pocket = false;
          SponsoredTopSites = false;
          SponsoredPocket = false;
          Snippets = true;
          TopSites = true;
        };
        FirefoxSuggest = {
          WebSuggestions = true;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
        };
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          };
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
          };
          "sponsorBlocker@ajay.app" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          };
        };
        HardwareAcceleration = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        PopupBlocking = {
          Default = true;
          Locked = false;
        };
        PostQuantumKeyAgreementEnabled = true;
        PromptForDownloadLocation = false;
        SearchBar = "unified";
        SearchSuggestEnabled = true;
        ShowHomeButton = false;
        StartDownloadsInTempDirectory = false;

        Preferences = {
          # Found by visiting URL: "about:config" in firefox
          "accessibility.typeaheadfind" = disabledLocked;
          "browser.aboutConfig.showWarning" = disabled;
          "browser.backspace_action" = {
            Value = 0;
          };
          "browser.compactmode.show" = enabled;
          "browser.display.use_system_colors" = enabled;
          "browser.download.autohideButton" = disabled;
          "browser.ml.chat.enabled" = enabled;
          "browser.ml.chat.provider" = {
            Value = "https://claude.ai/new";
          };
          "browser.uidensity" = {
            Value = 1;
          };
          "browser.warnOnQuitShortcut" = disabled;
          "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = enabled;
        };
      };
    };
  };
}
