{
  pkgs,
  lib,
  config,
  user,
  ...
}:
let
  inherit (lib)
    makeSearchPath
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.noaccOSModules.gnome;
in
{
  options.noaccOSModules.gnome = {
    enable = mkEnableOption "Gnome desktop environment";
    barebones = mkOption {
      type = types.bool;
      description = "Do not enable gnome desktop, only core components";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nautilus-python ];
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

    home-manager.users.${user}.homeModules.gnome.enable = !cfg.barebones;
    programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

    services.gnome.core-os-services.enable = true;
    services.gnome.core-shell.enable = true;
    services.gnome.core-utilities.enable = true;

    services.gnome.gnome-browser-connector.enable = !cfg.barebones;
    services.gnome.gnome-initial-setup.enable = !cfg.barebones;
    services.gnome.gnome-remote-desktop.enable = !cfg.barebones;
    # services.gnome.gnome-settings-daemon.enable = mkForce !cfg.barebones;

    noaccOSModules.virtualization.qemu-frontend = mkDefault pkgs.gnome-boxes;

    services.xserver = mkIf (!cfg.barebones) {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
