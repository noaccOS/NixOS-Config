{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.programs.terminals.foot;
in
{
  options.homeModules.programs.terminals.foot = {
    enable = lib.mkEnableOption "foot";
  };

  config.programs = {
    foot = {
      enable = cfg.enable;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=11";
          pad = "20x20";
        };
        colors = {
          foreground = "cdd6f4"; # Text
          background = "1e1e2e"; # Base
          regular0 = "45475a"; # Surface 1
          regular1 = "f38ba8"; # red
          regular2 = "a6e3a1"; # green
          regular3 = "f9e2af"; # yellow
          regular4 = "89b4fa"; # blue
          regular5 = "f5c2e7"; # pink
          regular6 = "94e2d5"; # teal
          regular7 = "bac2de"; # Subtext 1
          bright0 = "585b70"; # Surface 2
          bright1 = "f38ba8"; # red
          bright2 = "a6e3a1"; # green
          bright3 = "f9e2af"; # yellow
          bright4 = "89b4fa"; # blue
          bright5 = "f5c2e7"; # pink
          bright6 = "94e2d5"; # teal
          bright7 = "a6adc8"; # Subtext 0
        };
        csd = {
          preferred = "client";
        };
      };
    };
  };
}