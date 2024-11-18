_: {
  config = {
    programs.firefox = {
      enable = true;
      # nativeMessagingHosts = [  ];
      policies = {
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        FirefoxHome = {
          TopSites = true;
          SponsoredTopSites = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = true;
          Locked = false;
        };
        FirefoxSuggest = {
          WebSuggestions = true;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = false;
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
      };
    };
  };
}
