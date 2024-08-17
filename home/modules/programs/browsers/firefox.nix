{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optional
    optionals
    types
    ;

  cfg = config.homeModules.programs.browsers.firefox;
  ffcfg = config.programs.firefox;
  rycee = pkgs.callPackages (inputs.rycee + "/default.nix") { };

  defaultProfileSettings = {
    search.default = "Brave";
    search.privateDefault = "Brave";
    settings = {
      "browser.toolbars.bookmarks.visibility" = "never";
      "signon.rememberSignons" = false;
    };
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
        "nixpkgs issues" = {
          urls = [ { template = "https://github.com/NixOS/nixpkgs/issues?q={searchTerms}"; } ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@ni" ];
        };
        "Noogle" = {
          urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@ne" ];
        };
        "Home Manager" = {
          urls = [
            {
              template = "https://home-manager-options.extranix.com";
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
      let
        ffext = rycee.firefox-addons;
      in
      [
        ffext.bitwarden
        ffext.consent-o-matic
        ffext.darkreader
        ffext.firefox-color
        ffext.libredirect
        ffext.multi-account-containers
        ffext.privacy-badger
        ffext.sponsorblock
        ffext.stylus
        ffext.ublock-origin
      ]
      ++ optionals cfg.gnomeIntegration [
        ffext.gnome-shell-integration
        ffext.gsconnect
      ];
  };

  gnomeThemeProfileSettings = mkIf cfg.gnomeIntegration {
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

  finalProfileSettings = mkMerge [
    defaultProfileSettings
    gnomeThemeProfileSettings
    containers
  ];
in
{
  options.homeModules.programs.browsers.firefox = {
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

  config = mkMerge [
    (mkIf cfg.enable {
      programs.firefox = {
        enable = true;
        package =
          let
            nativeMessagingHosts =
              cfg.extraNativeMessagingHosts
              ++ optional cfg.gnomeIntegration pkgs.gnome-browser-connector;
          in
          cfg.package.override { inherit nativeMessagingHosts; };
        profiles = {
          default = finalProfileSettings;
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
