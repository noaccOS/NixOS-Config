{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.homeModules.programs.terminals.kitty;
in
{
  options.homeModules.programs.terminals.kitty = {
    enable = mkEnableOption "kitty";
  };

  config.programs.kitty = mkIf cfg.enable {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 16;
    };
    settings = {
      cursor_shape = "beam";
      cursor_blink_interval = "0";
      mouse_hide_wait = "0";
    };
  };
}
