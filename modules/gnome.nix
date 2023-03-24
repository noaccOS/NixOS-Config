{ pkgs, lib, ... }:
{
  environment.systemPackages = [
    pkgs.adw-gtk3

    pkgs.blackbox-terminal
    pkgs.celluloid

    pkgs.gnome.gnome-tweaks
    pkgs.gnome.nautilus-python
    
    pkgs.gnomeExtensions.dash-to-dock
  ];

  environment.sessionVariables = {
    GST_PLUGIN_PATH_1_0 = lib.makeSearchPath "lib/gstreamer-1.0" (
      with pkgs.gst_all_1;[
        gst-plugins-bad
        gst-plugins-good
        gst-plugins-ugly
        gst-vaapi
      ]
    );
  };
  programs = {
    kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
    # chromium.extensions = [
    #   "gphhapmejobijbbhgpjhcjognlahblep" # GNOME Shell Integration
    # ];
  };
  services.gvfs.enable = true;  
  services.xserver = {
    displayManager.gdm.enable = true;

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = builtins.readFile ./gnome/gsettings;
    };
  };
}
