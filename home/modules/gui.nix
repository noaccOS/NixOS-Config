{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.gui;
in
{
  options.homeModules.gui.enable = lib.mkEnableOption "gui programs";

  config.homeModules.programs = lib.mkIf cfg.enable {
    editors.emacs.enable = false;
    editors.vscode.enable = true;
    terminals.foot.enable = true;
    terminals.wezterm.enable = false;
    video.mpv.enable = true;
  };
}
