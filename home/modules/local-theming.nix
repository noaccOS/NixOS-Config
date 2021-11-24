{ config, lib, pkgs, ... }:
let
  currentTheme = config.services.theming.theme.defaultTheme;

  allThemes = {
    bat     = { dracula = "Dracula";     nord = "Nord"; };
    wezterm = { dracula = "TrueDracula"; nord = "nord"; };
  };

  # themes = map (x: x.${currentTheme}) allThemes;
  themes = { bat = "Dracula"; wezterm = "TrueDracula"; };
  
in {
  programs = {
    bat.config.theme = themes.bat;
    wezterm.theme = themes.wezterm;
  };
}
