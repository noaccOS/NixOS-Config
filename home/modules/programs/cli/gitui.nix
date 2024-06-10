{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homeModules.programs.cli.gitui;
in
with lib;
{
  options.homeModules.programs.cli.gitui = {
    enable = mkEnableOption "gitui";
  };
  config.programs.gitui = {
    enable = cfg.enable;
    keyConfig = ''
      move_left: Some(( code: Char('h'), modifiers: "" )),
      move_down: Some(( code: Char('t'), modifiers: "" )),
      move_up: Some(( code: Char('n'), modifiers: "" )),
      move_right: Some(( code: Char('s'), modifiers: "" )),
      tab_status: Some(( code: Char('\${"'"}'), modifiers: "" )),
      tab_log: Some(( code: Char(','), modifiers: "" )),
      tab_files: Some(( code: Char('.'), modifiers: "" )),
      tab_stashing: Some(( code: Char('p'), modifiers: "" )),
      tab_stashes: Some(( code: Char('y'), modifiers: "" )),

      toggle_workarea: Some(( code: Char('o'), modifiers: "" )),
      open_options: Some(( code: Char('o'), modifiers: "CONTROL" )),
      open_help: Some(( code: Char('?'), modifiers: "SHIFT" )),
      shift_up: Some(( code: Char('N'), modifiers: "SHIFT" )),
      shift_down: Some(( code: Char('T'), modifiers: "SHIFT" )),
    '';

    catppuccin.enable = false;
    theme = builtins.path {
      name = "catppuccin-${config.catppuccin.flavor}.ron";
      path = "${config.catppuccin.sources.gitui}/themes/catppuccin-${config.catppuccin.flavor}.ron";
    };

    config.catppuccin.sources.gitui.outPath = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "gitui";
      rev = "c7661f043cb6773a1fc96c336738c6399de3e617";
      hash = "sha256-CRxpEDShQcCEYtSXwLV5zFB8u0HVcudNcMruPyrnSEk=";
    };
  };
}
