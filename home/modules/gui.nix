{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.gui;
in
{
  options.homeModules.gui.enable = lib.mkEnableOption "gui programs";

  config.homeModules.programs = lib.mkIf cfg.enable {
    browsers.firefox.enable = true;
    browsers.firefox.defaultBrowser = lib.mkDefault true;
    editors.vscode.enable = true;
    terminals.alacritty.enable = true;
    terminals.kitty.enable = true;
    terminals.rio.enable = true;
    video.mpv.enable = true;
  };
}
