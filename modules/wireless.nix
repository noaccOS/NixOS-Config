{
  pkgs,
  user,
  config,
  lib,
  ...
}:
let
  cfg = config.noaccOSModules.wireless;

  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.noaccOSModules.wireless.enable = mkEnableOption "Wifi and bluetooth";

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez-experimental;
      settings.General.Experimental = true;
      settings.General.FastConnectable = true;
      settings.General.MultiProfile = "multiple";
    };

    networking = {
      wireless.iwd = {
        enable = true;
      };
      networkmanager.wifi.backend = "iwd";
    };

    services.connman.wifi.backend = "iwd";
  };
}
