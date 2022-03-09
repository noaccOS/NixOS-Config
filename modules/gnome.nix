{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
    pkgs.gnomeExtensions.dash-to-dock
  ];
  services.gvfs.enable = true;  
  services.xserver = {
    # displayManager.gdm = {
    #   enable = true;
    #   nvidiaWayland = true;
    # };

    displayManager.sddm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
