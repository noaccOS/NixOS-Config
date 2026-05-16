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

  webPorts = [
    80
    443
  ];
  blockyPorts = [
    53
    4000
  ];
  allowedTCPPorts = webPorts ++ blockyPorts;
  allowedUDPPorts = webPorts ++ blockyPorts;
in
{
  options.noaccOSModules.server = {
    enable = lib.mkEnableOption "Configuration for a server device";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      inherit allowedTCPPorts allowedUDPPorts;
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
    };

    noaccOSModules.docker.enable = true;
  };
}
