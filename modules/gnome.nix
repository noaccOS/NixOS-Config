{
  pkgs,
  lib,
  config,
  currentUser,
  ...
}:
let
  cfg = config.noaccOSModules.gnome;
in
{
  options.noaccOSModules.gnome = {
    enable = lib.mkEnableOption "Gnome desktop environment";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.adw-gtk3

      pkgs.celluloid

      pkgs.gnome-tweaks
      pkgs.nautilus-python

      pkgs.gnomeExtensions.dash-to-dock
      pkgs.gnomeExtensions.quick-settings-tweaker
    ];

    environment.sessionVariables = {
      GST_PLUGIN_PATH_1_0 = lib.makeSearchPath "lib/gstreamer-1.0" (
        with pkgs.gst_all_1;
        [
          gst-plugins-bad
          gst-plugins-good
          gst-plugins-ugly
          gst-vaapi
        ]
      );
    };

    home-manager.users.${currentUser}.homeModules.programs.browsers.firefox.gnomeIntegration = true;

    programs = {
      kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
    };
    services.gnome = {
      gnome-browser-connector.enable = true;
    };
    services.gvfs.enable = true;
    services.xserver = {
      displayManager.gdm.enable = true;

      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = builtins.readFile ./gnome/gsettings;
      };
    };
  };
}
