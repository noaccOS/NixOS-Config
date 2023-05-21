{ pkgs, lib, config, ... }:
let
  cfg = config.noaccOSModules.nvidia;
in
{
  options.noaccOSModules.nvidia = {
    enable = lib.mkEnableOption "Nvidia gpu specific options";
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia.modesetting.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
