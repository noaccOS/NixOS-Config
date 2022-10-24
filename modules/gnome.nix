{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.blackbox-terminal
    pkgs.celluloid

    pkgs.gnome.gnome-tweaks
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
