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

    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";

      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
