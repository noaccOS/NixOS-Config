{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.homeModules.windowManagers.gnome-shell;

  inherit (lib) getExe mkEnableOption mkIf;

  programs = {
    terminal = getExe pkgs.kitty;
    fileManager = getExe pkgs.nautilus;
    # topBar = getExe inputs.ags;
    lockScreen = getExe pkgs.hyprlock;
  };
in
{
  options.homeModules.windowManagers.gnome-shell = {
    enable = mkEnableOption "gnome programs and looks";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      evolution-data-server-gtk4
      file-roller
      fragments
      gnome-calculator
      gnome-calendar
      gnome-disk-utility
      gnome-font-viewer
      gnome-online-accounts
      gnome-online-accounts-gtk
      gnome-maps
      gnome-software
      loupe
      nautilus
      papers
      seahorse
      yelp
    ];

    # programs.hyprlock.enable = true;
    # services.hypridle.enable = true;
    # programs.niri.enable = true;
  };
}
