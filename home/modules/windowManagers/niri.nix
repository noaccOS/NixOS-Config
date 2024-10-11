{
  pkgs,
  lib,
  config,
  inputs,
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

  programs = {
    terminal = getExe pkgs.kitty;
    fileManager = getExe pkgs.nautilus;
    # topBar = getExe inputs.ags;
    lockScreen = getExe pkgs.hyprlock;
  };
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
    # homeModules.windowManagers.bars.waybar.target = "niri.";
    # programs.hyprlock.enable = true;
    # services.hypridle.enable = true;
    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    programs.niri = {
      enable = true;

    };
  };
}
