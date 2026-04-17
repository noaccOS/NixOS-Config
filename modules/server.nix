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
    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ] # NGINX
      ++ [
        53
        4000
      ] # Blocky
      ++ [ 8096 ] # Jellyfin
      ++ [ 5201 ]; # iperf
      allowedUDPPorts = [
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
    };

    noaccOSModules.docker.enable = true;
  };
}
