{
  lib,
  config,
  ...
}:
let
  cfg = config.noaccOSModules.mt7927;
in
{
  options.noaccOSModules.mt7927 = {
    enable = lib.mkEnableOption "Support for Realtek MT7927";
  };

  config = lib.mkIf cfg.enable {
    hardware.mediatek-mt7927 = {
      enable = true;
      enableWifi = true;
      enableBluetooth = true;
      disableAspm = true;
    };
  };
}
