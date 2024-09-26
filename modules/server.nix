{
  pkgs,
  config,
  user,
  currentDomainName,
  lib,
  ...
}:
let
  cfg = config.noaccOSModules.server;
in
{
  options.noaccOSModules.server = {
    enable = lib.mkEnableOption "Configuration for a server device";
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "francesco.noacco2000@gmail.com";
      certs.${currentDomainName} = {
        webroot = "/var/lib/acme/.challenges";
        group = "nginx";
        extraDomainNames = [
          "jellyfin.${currentDomainName}"
          "nextcloud.${currentDomainName}"
        ];
      };
    };

    networking.firewall = {
      allowedTCPPorts =
        [
          80
          443
        ] # NGINX
        ++ [
          53
          4000
        ] # Blocky
        ++ [ 8096 ] # Jellyfin
        ++ [ 5201 ]; # iperf
      allowedUDPPorts =
        [
          80
          443
        ] # NGINX
        ++ [
          53
          4000
        ] # Blocky
        ++ [ 8096 ] # Jellyfin
        ++ [ 5201 ]; # iperf
    };

    services = {
      blocky = {
        enable = true;
        settings = {
          port = 53;
          httpPort = 4000;

          blocking.blackLists.ads = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" ];
          blocking.clientGroupsBlock.default = [ "ads" ];
          upstream.default = [
            "1.0.0.1"
            "1.1.1.1"
            "1.1.1.2"
            "1.0.0.2"
            "8.8.8.8"
            "8.8.4.4"
          ];
          customDNS.mapping = {
            "noaccos.ovh" = "192.168.1.9";
          };
        };
      };

      jellyfin.enable = true;

      postgresql = {
        enable = true;
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [
          {
            name = "nextcloud";
            ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
          }
        ];
      };

      nextcloud = {
        enable = true;
        https = true;
        package = pkgs.nextcloud25;
        hostName = "nextcloud.${currentDomainName}";
        home = "/data/nextcloud";
        maxUploadSize = "0";
        phpOptions = {
          memory_limit = "512M";
        };
        config = {
          adminpassFile = "/var/ncAdminPass";
          dbtype = "pgsql";
          dbhost = "/run/postgresql";
          adminuser = "root";
        };
      };

      nginx = {
        enable = true;

        # https://jellyfin.org/docs/general/networking/nginx/
        clientMaxBodySize = "20M";
        resolver.valid = "30s";
        recommendedProxySettings = true;

        virtualHosts = {
          "acmechallange.${currentDomainName}" = {
            # Catchall vhost, will redirect users to HTTPS for all vhosts
            serverAliases = [ "*.${currentDomainName}" ];
            locations."/.well-known/acme-challenge" = {
              root = "/var/lib/acme/.challenges";
            };
            locations."/" = {
              return = "301 https://$host$request_uri";
            };
          };

          # add SSL to nextcloud's virtualHost
          ${config.services.nextcloud.hostName} = {
            forceSSL = true;
            enableACME = true;
          };

          "jellyfin.${currentDomainName}" = {
            forceSSL = true;
            enableACME = true;
            locations = {
              "= /".return = "302 https://$host/web/";
              "/" = {
                proxyPass = "http://127.0.0.1:8096";
                extraConfig = ''
                  proxy_set_header X-Forwarded-Protocol $scheme;
                  proxy_buffering off;
                '';
              };
              "= /web/" = {
                proxyPass = "http://127.0.0.1:8096/web/index.html";
                extraConfig = ''
                  proxy_set_header X-Forwarded-Protocol $scheme;
                '';
              };
              "/socket" = {
                proxyPass = "http://127.0.0.1:8096";
                extraConfig = ''
                  proxy_http_version 1.1;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection "upgrade";
                  proxy_set_header X-Forwarded-Protocol $scheme;
                '';
              };
            };

            extraConfig = ''add_header Content-Security-Policy "default-src https: data: blob:; style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/accentlist.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/base.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/bottombarprogress.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/fixes.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/jf_font.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/overlayprogress.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/rounding.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/rounding_circlehover.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/smallercast.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/rounding_circlehover.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/cornerindicator/indicator_floating.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/cornerindicator/indicator_corner.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/effects/glassy.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/effects/pan-animation.css https://ctalvio.github.io/Monochromic/backdrop-hack_style.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/effects/hoverglow.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/effects/scrollfade.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/episodelist/episodes_compactlist.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/episodelist/episodes_grid.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/fields/fields_border.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/fields/fields_noborder.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/header/header_transparent.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/header/header_transparent-dashboard.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/login/login_frame.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/login/login_minimalistic.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/login/login_frame.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/presets/monochromic_preset.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/presets/kaleidochromic_preset.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/presets/novachromic_preset.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/titlepage/title_banner.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/titlepage/title_banner-logo.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/titlepage/title_simple.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/titlepage/title_simple-logo.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/type/light.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/type/dark.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/type/colorful.css https://cdn.jsdelivr.net/gh/CTalvio/Ultrachromic/type/dark_withaccent.css https://fonts.googleapis.com/css2; script-src 'self' 'unsafe-inline' https://www.gstatic.com/cv/js/sender/v1/cast_sender.js; worker-src 'self' blob:; connect-src 'self'; object-src 'none'; frame-ancestors 'self'";'';
          };
        };
      };
    };

    # ensure that postgres is running *before* running the setup
    systemd.services."nextcloud-setup" = {
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
    };

    virtualisation = {
      podman.enable = true;
    };

    users.groups.homeservices = { };
    users.users = {
      nginx.extraGroups = [
        "homeservices"
        "acme"
      ];
      jellyfin.extraGroups = [ "homeservices" ];
      nextcloud.extraGroups = [ "homeservices" ];
    };

    users.users.${user}.extraGroups = [
      "homeservices"
      "jellyfin"
      "podman"
    ];
  };
}
