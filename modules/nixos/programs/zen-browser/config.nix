{
  programs.zen-browser.policies = {
    OverrideFirstRunPage = "";
    DisableTelemetry = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableFormHistory = true;
    DisplayBookmarksToolbar = true;
    DontCheckDefaultBrowser = true;
    DisableSetDesktopBackground = true;
    PasswordManagerEnabled = false;
    OfferToSaveLogins = false;
    PromptForDownloadLocation = true;
    NoDefaultBookmarks = true;
    DisableAppUpdate = true;

    EnableTrackingProtection = {
      Cryptomining = true;
      Fingerprinting = true;
      Locked = true;
      Value = true;
    };

    FirefoxHome = {
      Search = true;
      Pocket = false;
      Snippets = false;
      TopSites = false;
      Highlights = false;
    };

    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };

    Cookies = {
      Behavior = "accept";
      ExpireAtSessionEnd = false;
      Locked = false;
    };

    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        "installation_mode" = "force_installed";
        "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
      "sponsorBlocker@ajay.app" = {
        "installation_mode" = "force_installed";
        "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
      };
      "user-agent-switcher@ninetailed.ninja" = {
        "installation_mode" = "force_installed";
        "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi";
      };
      "keepassxc-browser@keepassxc.org" = {
        "installation_mode" = "force_installed";
        "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
      };
      "search@kagi.com" = {
        "installation_mode" = "force_installed";
        "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/kagi-search-for-firefox/latest.xpi";
      };
    };
  };
}
