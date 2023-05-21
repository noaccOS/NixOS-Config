{ pkgs, config, lib, ... }:
let
  cfg = config.noaccOSModules.logitech;
in
{
  options.noaccOSModules.logitech = {
    enable = lib.mkEnableOption "Logitech service and driver for customizations";
  };

  config = lib.mkIf cfg.enable {
    environment.defaultPackages = [ pkgs.piper ];
    services.ratbagd.enable = true;
  };
}
