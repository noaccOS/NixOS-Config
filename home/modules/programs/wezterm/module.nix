{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.homeModules.packages.wezterm;
  sources = import ./sources { inherit lib cfg; };
in
{
  options.homeModules.packages.wezterm = {
    enable = mkEnableOption "wezterm";

    theme = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "nord";
      description = "Color scheme to use";
    };

    font = {
      family = mkOption {
        type = with types; listOf str;
        default = [ ];
        example = [ "JetBrains Mono" "JetBrainsMono Nerd Font" ];
        description = "List of fonts with fallback";
      };

      size = mkOption {
        type = types.int;
        default = 12;
        example = 10;
        description = "Font size";
      };
    };

    closePromptEnable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Show close confirmation prompt when there is a job running";
    };

    tabBarEnable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Enable tab bar";
    };

    waylandEnable = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Enable wayland support";
    };

    padding = {
      left = mkOption {
        type = types.int;
        default = 0;
        example = 20;
        description = "Left window padding";
      };
      right = mkOption {
        type = types.int;
        default = 0;
        example = 20;
        description = "Right window padding";
      };
      top = mkOption {
        type = types.int;
        default = 0;
        example = 20;
        description = "Top window padding";
      };
      bottom = mkOption {
        type = types.int;
        default = 0;
        example = 20;
        description = "Bottom window padding";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.wezterm ];

    xdg.configFile."wezterm/wezterm.lua".text = ''
      local wezterm = require 'wezterm';
      return {
        ${optionalString (cfg.theme != null)
          "color_scheme = '${cfg.theme}',"}
        ${optionalString (cfg.theme == "Catppuccin") (readFile catppuccinColors)}
        enable_tab_bar = ${trivial.boolToString cfg.tabBarEnable},
        window_close_confirmation = '${
                           if cfg.closePromptEnable
                           then
                             "AlwaysPrompt"
                           else
                             "NeverPrompt"
                         }',
        font = wezterm.font_with_fallback({
          ${
            concatMapStrings (x: "'${x}',\n") cfg.font.family
          }
        }),
        enable_wayland = ${trivial.boolToString cfg.waylandEnable},
        font_size = ${toString cfg.font.size},
        window_padding = {
          left = ${toString cfg.padding.left},
          right = ${toString cfg.padding.right},
          top = ${toString cfg.padding.top},
          bottom = ${toString cfg.padding.bottom},
        },
        use_ime = false,
      }
    '';
  };
}
