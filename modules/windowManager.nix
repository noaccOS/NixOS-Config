{
  inputs,
  lib,
  config,
  currentUser,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    optional
    types
    ;
  cfg = config.noaccOSModules.windowManager;
in
{
  options.noaccOSModules.windowManager = {
    enable = mkEnableOption "window managers";

    windowManager = mkOption {
      description = "The window manager to enable";
      type = types.enum [
        "niri"
      ];
      default = "niri";
    };
  };

  config = mkIf cfg.enable {
    noaccOSModules.gnome.enable = true;
    noaccOSModules.gnome.barebones = true;

    services.greetd.enable = true;

    programs.niri = {
      enable = cfg.windowManager == "niri";
    };

    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    home-manager.users.${currentUser}.homeModules.windowManagers.${cfg.windowManager}.enable = true;
  };
}
