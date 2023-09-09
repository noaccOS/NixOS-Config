{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.programs.terminals.wezterm;
in
{
  options.homeModules.programs.terminals.wezterm.enable = lib.mkEnableOption "custom wezterm";

  config.homeModules.programs.terminals.wezterm.packageModule = {
    enable = cfg.enable;
    font = {
      family = [
        "JetBrainsMono Nerd Font"
        "JetBrains Mono"
        "Segoe UI Symbol"
        "Cambria"
        "JoyPixels"
      ];
      size = 12;
    };
    closePromptEnable = false;
    tabBarEnable = false;
    waylandEnable = false;
    padding = {
      left = 20;
      right = 20;
      top = 20;
      bottom = 20;
    };
  };
}
