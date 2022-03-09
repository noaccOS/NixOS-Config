{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.programs.wezterm;
  catppuccinColors = fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/wezterm/74b23a608d02e6b132d91bb2dcf9cb37de89f466/wezterm.lua";
    sha256 = "0zi5nzkk4y0fd3zffmyj4pl56yma735dmwn13ngk1r92v1zv63gp";
  };
in
{
  options.programs.wezterm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Wether to enable the wezterm module";
    };

    theme = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "nord";
      description = "Color scheme to use";
    };

    font = {
      family = mkOption {
        type = with types; listOf str;
        default = [];
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
        }
      '';

    xdg.configFile."wezterm/colors/TrueDracula.toml".text = ''
        [colors]
        foreground = "#f8f8f2"
        background = "#282a36"
        cursor_bg = "#bd93f9"
        cursor_border = "#bd93f9"
        cursor_fg = "#282a36"
        selection_bg = "#44475a"
        selection_fg = "#f8f8f2"
        
        ansi = ["#000000","#ff5555","#50fa7b","#f1fa8c","#bd93f9","#ff79c6","#8be9fd","#bbbbbb"]
        brights = ["#555555","#ff5555","#50fa7b","#f1fa8c","#bd93f9","#ff79c6","#8be9fd","#ffffff"]
      '';
    
    xdg.configFile."wezterm/colors/Catppuccin.toml".source = fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/wezterm/74b23a608d02e6b132d91bb2dcf9cb37de89f466/Catppuccin.toml";
      sha256 = "0ns40b5lnsxks41nlw19y2wawnhraxvfgs88qi6x6l9f63dj2dvx";
    };
  };
}
