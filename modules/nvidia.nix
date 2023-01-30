{pkgs, lib, ...}:
{
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers      = [ "nvidia" ];
}
