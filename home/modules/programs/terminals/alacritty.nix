{ config, lib, ... }:
let cfg = config.homeModules.programs.terminals.alacritty;
in with lib; {
  options.homeModules.programs.terminals.alacritty = {
    enable = mkEnableOption "alacritty";
  };

  config.programs.alacritty = {
    enable = cfg.enable;
    catppuccin.enable = true;
    settings = {
      font.size = 14;
      font.normal.family = "JetBrainsMono Nerd Font";
    };
  };
}
