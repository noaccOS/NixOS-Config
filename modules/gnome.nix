{pkgs, ...}:
{
  services.xserver = {
    displayManager.gdm = {
      enable = true;
      nvidiaWayland = true;
    };

    desktopManager.gnome.enable = true;
  };
}
