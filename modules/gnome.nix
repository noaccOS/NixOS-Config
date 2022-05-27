{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
    # pkgs.gnomeExtensions.dash-to-dock
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
