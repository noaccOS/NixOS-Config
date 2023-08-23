{ config, lib, pkgs, ... }:
let
  cfg = config.homeModules.theming;

  allThemes = import theming/themes.nix;
  allSources = import theming/sources.nix;

  themes = lib.mapAttrs (_name: themes: themes.${cfg.theme}) allThemes;
  sources =lib.mapAttrs (_name: sources: sources.${cfg.theme}) allSources;
in
{
  options.homeModules.theming = {
    enable = lib.mkEnableOption "custom theming";
    theme = lib.mkOption {
      type = lib.types.enum [ "dracula" "nord" "catppuccin" ];
      default = "catppuccin";
    };
  };

  config = lib.mkIf cfg.enable {
  programs = {
    bat = {
      config.theme = themes.bat;
      themes = lib.mkIf (sources.bat != null) {
        ${themes.bat} = sources.bat;
      };
  };
  };

  homeModules = {
    packages = {
      wezterm.theme = themes.wezterm;
    };
  };

  xdg.configFile = lib.mkIf (sources.wezterm.dest != null) {
    "wezterm/colors/${sources.wezterm.dest}".source = sources.wezterm.src;
  };

  };
}
