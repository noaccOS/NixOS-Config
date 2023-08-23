{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.gui;
  in
{
  options.homeModules.gui.enable = lib.mkEnableOption "gui programs";

  config.homeModules = {
      emacs.enable = cfg.enable;
      foot.enable = cfg.enable;
      mpv.enable = cfg.enable;
      vscode.enable = cfg.enable;
      wezterm.enable = cfg.enable;
  };
}
