{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
    pkgs.celluloid
    pkgs.gnome.nautilus-python
    pkgs.gnomeExtensions.dash-to-dock-for-cosmic
  ];
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  services.gvfs.enable = true;  
  services.xserver = {
    displayManager.gdm.enable = true;

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.desktop.wm.preferences]
        resize-with-right-button=true
      '';
    };
  };
}
