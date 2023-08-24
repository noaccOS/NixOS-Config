{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.gui;
in
{
  options.homeModules.gui.enable = lib.mkEnableOption "gui programs";

  config.homeModules = {
    programs.emacs.enable = cfg.enable;
    programs.foot.enable = cfg.enable;
    programs.mpv.enable = cfg.enable;
    programs.vscode.enable = cfg.enable;
    programs.wezterm.enable = cfg.enable;
  };
}
