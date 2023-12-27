{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.gui;
in
{
  options.homeModules.gui.enable = lib.mkEnableOption "gui programs";

  config.homeModules.programs = lib.mkIf cfg.enable {
    editors.vscode.enable = true;
    terminals.foot.enable = true;
    video.mpv.enable = true;
  };
}
