{
  pkgs,
  lib,
  config,
  currentUser,
  ...
}:
let
  inherit (lib)
    pipe
    types
    makeSearchPath
    mkOption
    mkEnableOption
    mkIf
    ;
  inherit (builtins) readFile fromTOML;
  cfg = config.noaccOSModules.gnome;
in
{
  options.noaccOSModules.gnome = {
    enable = mkEnableOption "Gnome desktop environment";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = {
      GST_PLUGIN_PATH_1_0 = makeSearchPath "lib/gstreamer-1.0" (
        with pkgs.gst_all_1;
        [
          gst-plugins-bad
          gst-plugins-good
          gst-plugins-ugly
          gst-vaapi
        ]
      );
    };

    home-manager.users.${currentUser}.homeModules.gnome.enable = true;
    programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;
    services.gnome.gnome-browser-connector.enable = true;
    services.gvfs.enable = true;
    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
