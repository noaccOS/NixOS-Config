{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
    pkgs.gnomeExtensions.dash-to-dock
  ];
  
  services.xserver = {
    displayManager.gdm = {
      enable = true;
      nvidiaWayland = true;
    };

    desktopManager.gnome.enable = true;
  };
}
