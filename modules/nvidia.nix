{
  lib,
  config,
  ...
}:
let
  cfg = config.noaccOSModules.nvidia;
  inherit (lib)
    mkEnableOption
    mkIf
    ;
in
{
  options.noaccOSModules.nvidia = {
    enable = mkEnableOption "Nvidia gpu specific options";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
    };

    hardware.nvidia = {
      modesetting.enable = true;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = true;
      nvidiaPersistenced = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
    };

    nix.settings = {
      extra-substituters = [ "https://cache.nixos-cuda.org/?priority=41" ];
      trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
    };
  };
}
