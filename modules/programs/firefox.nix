{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.programs.firefox;
in {
  config = mkIf cfg.enable {
    programs.firefox = {
      package = pkgs.firefox;

      policies = {
        # Default policies - these shouldn't be opt out :/
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

        # Additional policies
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

        # Search Engine, this will only work on Firefox ESR which is pretty annoying.
        SearchEngines = {
          Add = [
            {
              Name = "kagi";
              Description = "Paid premium search engine.";
              Alias = "!kg";
              Method = "GET";
              URLTemplate = "https://kagi.com/search?q={searchTerms}";
            }
            {
              Name = "nixpkgs";
              Description = "Nixpkgs query";
              Alias = "!nix";
              Method = "GET";
              URLTemplate = "https://search.nixos.org/packages?&query={searchTerms}";
            }
          ];
          Default = "Kagi";
        };

        # Declarative Extensions
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
          "privacypass@kagi.com" = {
            "installation_mode" = "force_installed";
            "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/kagi-privacy-pass/latest.xpi";
          };
        };
      };

      preferences = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
      };
    };
  };
}
