{ config, lib, pkgs, ... }:
let
  currentTheme = config.services.theming.theme.defaultTheme;

  allThemes = {
    bat = { dracula = "Dracula"; nord = "Nord"; };
    wezterm = { dracula = "TrueDracula"; nord = "nord"; catppuccin = "Catppuccin"; };
  };

  # themes = map (x: x.${currentTheme}) allThemes;
  themes = { bat = "Dracula"; wezterm = "Catppuccin"; };

in
{
  programs = {
    bat.config.theme = themes.bat;
    noaccos-wezterm.theme = themes.wezterm;
  };
}
