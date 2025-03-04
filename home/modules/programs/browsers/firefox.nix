{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (builtins)
    elemAt
    filter
    fromJSON
    listToAttrs
    readFile
    split
    typeOf
    ;
  inherit (lib)
    forEach
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optional
    optionals
    pipe
    types
    ;

  cfg = config.homeModules.programs.browsers.firefox;
  ffcfg = config.programs.firefox;
  rycee = pkgs.callPackages (inputs.rycee + "/default.nix") { };

  betterfox =
    let
      parsePrefs =
        contents:
        pipe contents [
          (split "\n")
          (filter (line: typeOf line == "string"))
          (map (builtins.match "user_pref\\(\"(.*)\",[[:space:]]*([^[:space:]]*)\\).*"))
          (filter (a: !isNull a))
          (map (
            pref:
            let
              name = elemAt pref 0;
              value = fromJSON (elemAt pref 1);
            in
            {
              inherit name value;
            }
          ))
          listToAttrs
        ];
      selectedFiles = [ "user.js" ];
      prefs_per_file = forEach selectedFiles (
        file:
        pipe file [
          (f: "${inputs.betterfox}/${f}")
          readFile
          parsePrefs
        ]
      );
    in
    {
      settings = mkMerge prefs_per_file;
    };

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

        Jisho = {
          urls = [ { template = "https://jisho.org/search/{searchTerms}"; } ];
          iconUpdateURL = "https://assets.jisho.org/assets/favicon-062c4a0240e1e6d72c38aa524742c2d558ee6234497d91dd6b75a182ea823d65.ico";
          updateInterval = updateDaily;
          definedAliases = [ "@j" ];
        };

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
                {
                  name = "release";
                  value = "master";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@hm" ];
        };
      };

    extensions.packages =
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
        ffext.refined-github
        ffext.sponsorblock
        ffext.stylus
        ffext.ublock-origin
        ffext.yomitan
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

  mainContainer =
    if config.homeModules.work.enable then
      {
        name = "personal";
        color = "blue";
        icon = "fingerprint";
      }
    else
      {
        name = "work";
        color = "pink";
        icon = "dollar";
      };

  containers = {
    containersForce = true;
    containers = {
      ${mainContainer.name} = {
        id = 1;
        inherit (mainContainer) color icon;
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

      dev = {
        id = 4;
        color = "yellow";
        icon = "chill";
      };
    };
  };

  finalProfileSettings = mkMerge [
    betterfox
    containers
    defaultProfileSettings
    gnomeThemeProfileSettings
  ];

  mkProfile =
    id:
    mkMerge [
      finalProfileSettings
      { inherit id; }
    ];
in
{
  options.homeModules.programs.browsers.firefox = {
    enable = mkEnableOption "firefox";
    defaultBrowser = mkEnableOption "firefox as the default web browser";
    gnomeIntegration = mkEnableOption "gnome integration for firefox" // {
      default = true;
    };
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
          default = mkProfile 0;
          clean = mkProfile 1;
          guest = mkProfile 2;
        };
      };

      home.file.".mozilla/firefox/firefox-gnome-theme" = mkIf cfg.gnomeIntegration {
        source = inputs.firefox-gnome-theme;
      };
    })

    (mkIf (cfg.enable && cfg.defaultBrowser) {
      xdg.mimeApps.defaultApplications = {
        "application/rdf+xml" = "firefox.desktop";
        "application/rss+xml" = "firefox.desktop";
        "application/vnd.mozilla.xul+xml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/xhtml_xml" = "firefox.desktop";
        "application/x-mimearchive" = "firefox.desktop";
        "application/xml" = "firefox.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "x-scheme-handler/webcal" = "firefox.desktop";
      };

      home.sessionVariables.DEFAULT_BROWSER = "${ffcfg.finalPackage}/bin/firefox";
    })
  ];
}
