{ pkgs, currentUser, ... }:
{
  imports = [ ./base.nix ];

  # secutrity.acme = {
  #   acceptTerms = true;
  #   defaults.email = "francesco.noacco2000@gmail.com";
  # };
  
  services = {
    jellyfin.enable = true;

    nginx = {
      enable = true;

      # https://jellyfin.org/docs/general/networking/nginx/
      clientMaxBodySize = "20M";
      resolver.valid = "30s";
      recommendedProxySettings = true;

      virtualHosts = {
        "jellyfin.noaccos.ovh" = {
          # addSSL = true;
          # enableACME = true;
          locations = {
            "= /".return = "302 http://$host/web/";
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
        };
      };
    };
  };

  virtualisation = {
    podman.enable = true;
  };

  users.users.${currentUser}.extraGroups = [ "jellyfin" "podman" ];
}
