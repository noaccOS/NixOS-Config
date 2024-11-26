{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homeModules.windowManagers.niri;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.homeModules.windowManagers.niri = {
    enable = mkEnableOption "niri";
    greeter-command = mkOption {
      type = types.str;
      readOnly = true;
      default = getExe config.programs.niri.package;
    };
    package = mkOption {
      type = types.package;
      readOnly = true;
      default = config.programs.niri.package;
    };
  };
  config = mkIf cfg.enable {
    homeModules.windowManagers.gnome-shell.enable = true;
    homeModules.programs.launchers.anyrun.enable = true;
    homeModules.windowManagers.bars.waybar.enable = true;

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];

    programs.niri = {
      enable = true;

    };
  };
}
