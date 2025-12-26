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
      # fixme: build failure
      # nvidiaPersistenced = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
    };

    nix.settings = {
      extra-substituters = [ "https://cache.flox.dev/?priority=41" ];
      trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];

    };
  };
}
