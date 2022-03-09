{pkgs, lib, ...}:
{
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers      = [ "nvidia" ];

  # options.nvidia.removeXTearing = lib.mkOption{
  #   description = "Remove tearing for X sessions";
  #   default = true;
  #   type = pkgs.types.bool;
  # };
}
