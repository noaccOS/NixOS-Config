{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.kde-gtk-config
    pkgs.latte-dock
    pkgs.plasma-browser-integration
    pkgs.libsForQt5.krunner
  ];
  
  services.xserver = {
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
    };

    desktopManager.plasma5.enable = true;
  };
}
