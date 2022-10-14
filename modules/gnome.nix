{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
    pkgs.celluloid
    pkgs.gnome.nautilus-python
    pkgs.gnomeExtensions.dash-to-dock
  ];
  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
  services.gvfs.enable = true;  
  services.xserver = {
    displayManager.gdm.enable = true;

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = builtins.readFile ./gnome/gsettings;
    };
  };
}
