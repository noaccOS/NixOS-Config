{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.homeModules.windowManagers.niri;

  inherit (lib) getExe mkEnableOption mkIf;

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
  };
  config = mkIf cfg.enable {
    # programs.hyprlock.enable = true;
    # services.hypridle.enable = true;
    # programs.niri.enable = true;
  };
}
