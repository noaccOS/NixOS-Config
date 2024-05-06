{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.homeModules.programs.browsers.firefox;
  ffcfg = config.programs.firefox;
  rycee = import (inputs.rycee + "/default.nix") { inherit pkgs; };

  defaultProfileSettings = {
    search.default = "Brave";
    search.privateDefault = "Brave";
    search.order = [
      "Brave"
      "Nix Packages"
      "Google"
    ];
    search.force = true;
    search.engines =
      let
        updateDaily = 86400000;
      in
      {
        "Brave" = {
          urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
          iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/favicon.c09fe1a1.ico";
          updateInterval = updateDaily;
          definedAliases = [ "@b" ];
        };
        "Bing".metaData.hidden = true;
        "Google".metaData.alias = "@g";

        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@n" ];
        };
        "NixOS Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" ];
        };
        "NixOS Wiki" = {
          urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
          iconUpdateURL = "https://nixos.wiki/favicon.png";
          updateInterval = updateDaily;
          definedAliases = [ "@nw" ];
        };
        "Home Manager" = {
          urls = [
            {
              template = "https://mipmip.github.io/home-manager-option-search";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@hm" ];
        };
      };

    extensions =
      with rycee.firefox-addons;
      [
        bitwarden
        consent-o-matic
        darkreader
        firefox-color
        libredirect
        multi-account-containers
        privacy-badger
        sponsorblock
        stylus
        ublock-origin
      ]
      ++ lib.lists.optionals cfg.gnomeIntegration [
        gnome-shell-integration
        gsconnect
      ];
  };

  gnomeThemeProfileSettings = lib.mkIf cfg.gnomeIntegration {
    userChrome = ''
      @import "../../firefox-gnome-theme/userChrome.css"
    '';
    userContent = ''
      @import "../../firefox-gnome-theme/userContent.css"
    '';

    settings = {
      "browser.theme.dark-private-windows" = false;
      "browser.uidensity" = 0;
      "gnomeTheme.closeOnlySelectedTabs" = true;
      "gnomeTheme.hideSingleTab" = true;
      "svg.context-properties.content.enabled" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "widget.gtk.rounded-bottom-corners.enabled" = true;
    };
  };

  containers = {
    containersForce = true;
    containers = {
      work = {
        id = 1;
        color = "pink";
        icon = "dollar";
      };

      guest = {
        id = 2;
        color = "purple";
        icon = "gift";
      };

      clean = {
        id = 3;
        color = "turquoise";
        icon = "fence";
      };
    };
  };

  finalProfileSettings = lib.mkMerge [
    defaultProfileSettings
    gnomeThemeProfileSettings
    containers
  ];
in
{
  options.homeModules.programs.browsers.firefox = with lib; {
    enable = mkEnableOption "firefox";
    defaultBrowser = mkEnableOption "firefox as the default web browser";
    gnomeIntegration = mkEnableOption "gnome integration for firefox";
    extraNativeMessagingHosts = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
    package = mkOption {
      type = types.package;
      default = pkgs.firefox;
    };
    profileSettinsgOverrides = mkOption {
      type = types.attrSet;
      default = { };
    };
  };

  config =
    with lib;
    mkMerge [
      (mkIf cfg.enable {
        programs.firefox = {
          enable = true;
          package =
            let
              nativeMessagingHosts =
                cfg.extraNativeMessagingHosts
                ++ lib.lists.optional cfg.gnomeIntegration pkgs.gnome-browser-connector;
            in
            cfg.package.override { inherit nativeMessagingHosts; };
          profiles = {
            default = finalProfileSettings // {
              id = 0;
            };
          };
        };

        home.file.".mozilla/firefox/firefox-gnome-theme" = mkIf cfg.gnomeIntegration {
          source = inputs.firefox-gnome-theme;
        };
      })

      (mkIf (cfg.enable && cfg.defaultBrowser) {
        xdg.mimeApps.defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
        };

        home.sessionVariables.DEFAULT_BROWSER = "${ffcfg.finalPackage}/bin/firefox";
      })
    ];
}
