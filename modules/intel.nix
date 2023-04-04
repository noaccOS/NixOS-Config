{pkgs, lib, ...}:
{
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    intel-media-driver
  ];
}
