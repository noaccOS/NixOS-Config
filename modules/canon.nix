{
  pkgs,
  user,
  lib,
  config,
  ...
}:
let
  cfg = config.noaccOSModules.canon;
in
{
  options.noaccOSModules.canon.enable = lib.mkEnableOption "Module to enable my personal printer (canon mx495) to work";

  config = lib.mkIf cfg.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      openFirewall = true;
    };
    users.users.${user}.extraGroups = [
      "scanner"
      "lp"
      "avahi"
    ];
    services.printing = {
      enable = true;
      # drivers = [ pkgs.cnijfilter2 ];
    };
  };
}
