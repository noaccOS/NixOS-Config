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
    prowrlarr = config.services.prowlarr.settings.server.port;
    sonarr = config.services.sonarr.settings.server.port;
    deluge = config.services.deluge.web.port;
    jellyfin = 8096;
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
        subdomains = concatMapAttrs (service: port: {
          "${service}.localhost".extraConfig = "redir http://localhost/${service}";
          "${service}.${currentDomainName}".extraConfig = "redir http://localhost/${service}";
        }) services;
        subpathsConfig = pipe services [
          (mapAttrsToList (
            service: port: ''
              redir /${service} /${service}/
              handle /${service}/* {
                reverse_proxy http://localhost:${toString port}
              }
            ''
          ))
          concatLines
        ];
        subpaths = {
          "localhost".extraConfig = subpathsConfig;
          ${currentDomainName}.extraConfig = subpathsConfig;
        };
      in
      subpaths // subdomains;

    services.deluge = {
      enable = true;
      web = {
        enable = true;
        openFirewall = true;
      };
    };

    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };

    services.sonarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
