{
  lib,
  config,
  ...
}:
let
  cfg = config.noaccOSModules.nvidia;
in
{
  options.noaccOSModules.nvidia = {
    enable = lib.mkEnableOption "Nvidia gpu specific options";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
    };

    hardware.nvidia = {
      modesetting.enable = true;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = true;
      # fixme: build failure
      # nvidiaPersistenced = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
    };
  };
}
