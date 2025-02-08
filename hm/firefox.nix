{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  locked = {Locked = true;};
  yes = locked // {Value = true;};
  no = locked // {Value = false;};
in {
  config = {
    programs.firefox = let
      firefoxConfig = {
        enable = true;
        # nativeMessagingHosts = [  ];
        policies = {
          DisplayBookmarksToolbar = "always";
          DisableFirefoxStudies = true;
          DisableFormHistory = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          EnableTrackingProtection =
            yes
            // {
              Cryptomining = true;
              Fingerprinting = true;
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
          HardwareAcceleration = true;
          Homepage =
            locked
            // {
              #URL = "https://.....com";
              #Additional = [ "https.....com" "https.....com" ];
              StartPage = "none"; # none/homepage/previous-session/homepage-locked
            };
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          PasswordManagerEnabled = false;
          PopupBlocking =
            locked
            // {
              Default = true;
            };
          PostQuantumKeyAgreementEnabled = true;
          PromptForDownloadLocation = false;
          RequestedLocales = ["en-GB" "en-US" "en-CA"];
          SearchBar = "unified";
          SearchSuggestEnabled = true;
          ShowHomeButton = false;
          StartDownloadsInTempDirectory = false;

          Preferences = {
            # Found by visiting URL: "about:config" in firefox
            "accessibility.typeaheadfind" = no;
            "browser.aboutConfig.showWarning" = no;
            "browser.backspace_action" = locked // {Value = 0;};
            "browser.compactmode.show" = yes;
            "browser.display.use_system_colors" = yes;
            "browser.download.autohideButton" = no;
            "browser.ml.chat.enabled" = no;
            "browser.sessionstore.max_resumed_crashes" = locked // {Value = -1;};
            # FF sets this to true on reboot, forcing a session restore
            "browser.sessionstore.resume_session_once" = no;
            "browser.uidensity" = locked // {Value = 1;};
            "browser.warnOnQuitShortcut" = no;
            "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = yes;
          };
        };
      };
      # https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#configuration
      # Mostly for NVIDIA but may benefit i915 too?
      enableVaapiConfig = {
        package = pkgs.firefox.overrideAttrs (oldAttrs: {
          buildCommand =
            oldAttrs.buildCommand
            + ''
              wrapProgram "$executablePath" \
                --set MOZ_DISABLE_RDD_SANDBOX 1
            '';
        });
        policies.Preferences = {
          "gfx.x11-egl.force-enabled" = 
            if osConfig.hardware.nvidia.enable
            then yes
            else no;
          # Only if HW supports AV1 decoding
          "media.av1.enabled" = lib.mkDefault yes;
          "media.ffmpeg.vaapi.enabled" = yes;
          "media.rdd-ffmpeg.enabled" = yes;
          "widget.dmabuf.force-enabled" = yes;
        };
      };
    in
      lib.recursiveUpdate firefoxConfig enableVaapiConfig;
  };
}
