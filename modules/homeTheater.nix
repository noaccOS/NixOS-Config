{
  config,
  currentDomainName,
  lib,
  user,
  ...
}:
let
  inherit (builtins) toString;
  inherit (lib)
    concatLines
    concatMapAttrs
    getExe'
    mapAttrs'
    mapAttrsToList
    nameValuePair
    pipe
    ;

  cfg = config.noaccOSModules.homeTheater;
  niriCfg = config.home-manager.users.${user}.programs.niri;
  niriBin = getExe' niriCfg.package "niri-session";

  services = {
    prowlarr = config.nixarr.prowlarr.port;
    sonarr = config.nixarr.sonarr.port;
    transmission = config.nixarr.transmission.uiPort;
    jellyfin = config.nixarr.jellyfin.port;
  };
in
{
  options.noaccOSModules.homeTheater = {
    enable = lib.mkEnableOption "Home Theater with Kodi";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user}.homeModules.homeTheater.enable = true;

    noaccOSModules.desktop.enable = true;

    # Temporarily use niri
    noaccOSModules.windowManager = {
      enable = true;
      primary = false;
    };

    # auto-login and launch kodi
    programs.regreet.enable = true;
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          inherit user;
          command = niriBin;
        };
      };
    };

    services.caddy.virtualHosts =
      let
        subdomains = concatMapAttrs (
          service: port:
          let
            proxy = "reverse_proxy http://localhost:${toString port}";
          in
          {
            "${service}.localhost".extraConfig = proxy;
            "${service}.${currentDomainName}".extraConfig = proxy;
          }
        ) services;
        # the services don't know about any url base, so send subpaths to their subdomain
        subpathsConfig = pipe services [
          (mapAttrsToList (service: port: "redir /${service}* http://${service}.{host}/"))
          concatLines
        ];
        subpaths = {
          "localhost".extraConfig = subpathsConfig;
          ${currentDomainName}.extraConfig = subpathsConfig;
        };
      in
      subpaths // subdomains;

    nixarr = {
      enable = true;
      mediaUsers = [ user ];

      jellyfin = {
        enable = true;
        openFirewall = true;
      };

      prowlarr = {
        enable = true;
        openFirewall = true;
        settings-sync.enable-nixarr-apps = true;
      };

      sonarr = {
        enable = true;
        openFirewall = true;
        settings-sync.transmission.enable = true;
      };

      transmission = {
        enable = true;
        openFirewall = true;
        flood.enable = true;
        extraSettings = {
          # caddy forwards the original Host header
          rpc-host-whitelist = "localhost,*.localhost,${currentDomainName},*.${currentDomainName}";
          sequential_download = true;
        };
      };
    };

    # required by nixarr's prowlarr settings-sync
    services.prowlarr.settings.auth.required = "DisabledForLocalAddresses";
    services.sonarr.settings.auth.required = "DisabledForLocalAddresses";
  };
}
