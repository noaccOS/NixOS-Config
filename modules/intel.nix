{ pkgs, lib, config, ... }:
let
  cfg = config.noaccOSModules.intel;
in
{
  options.noaccOSModules.intel = {
    enable = lib.mkEnableOption "Intel gpu specific options";
  };

  config = lib.mkIf cfg.enable {
    hardware.opengl.extraPackages = with pkgs; [
      vaapiIntel
      intel-media-driver
    ];
  };
}
