{
  config,
  currentDomainName,
  lib,
  pkgs,
  user,
  ...
}:
let
  inherit (builtins) toString;
  inherit (lib)
    concatLines
    concatMapAttrs
    escapeShellArg
    getExe
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
    services.displayManager.regreet.enable = true;
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
          "${service}.${currentDomainName}".extraConfig = "redir http://${currentDomainName}/${service}";
        }) services;
        # the services are configured with /<service> as their url base, so the path is kept as is
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
          rpc-host-whitelist = "localhost,${currentDomainName}";
          sequential_download = true;
        };
      };
    };

    # required by nixarr's prowlarr settings-sync
    services.prowlarr.settings.auth.required = "DisabledForLocalAddresses";
    services.sonarr.settings.auth.required = "DisabledForLocalAddresses";

    # url bases for the subpaths. nixarr's settings-sync picks up server.urlBase for the arrs, and
    # transmission already serves everything under /transmission/
    services.prowlarr.settings.server.urlBase = "/prowlarr";
    services.sonarr.settings.server.urlBase = "/sonarr";
    # jellyfin only reads its base url from network.xml, which it otherwise manages itself
    systemd.services.jellyfin.preStart = ''
      networkXml=${escapeShellArg "${config.services.jellyfin.configDir}/network.xml"}
      if [[ -e $networkXml ]]; then
        ${getExe pkgs.xmlstarlet} ed --inplace \
          --delete /NetworkConfiguration/BaseUrl \
          --subnode /NetworkConfiguration --type elem --name BaseUrl --value /jellyfin \
          "$networkXml"
      else
        mkdir -p "$(dirname "$networkXml")"
        cat > "$networkXml" <<EOF
      <?xml version="1.0" encoding="utf-8"?>
      <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <BaseUrl>/jellyfin</BaseUrl>
      </NetworkConfiguration>
      EOF
      fi
    '';
  };
}
