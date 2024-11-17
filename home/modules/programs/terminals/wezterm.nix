{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeModules.programs.terminals.wez;

  inherit (lib) getExe mkEnableOption optionalString;
in
{
  options.homeModules.programs.terminals.wez = {
    enable = mkEnableOption "wezterm";
  };

  config.programs.wezterm = {
    enable = cfg.enable;
    package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig = ''
      local config = wezterm.config_builder()

      config.color_scheme = 'Catppuccin Mocha'
      config.font = wezterm.font_with_fallback {
       'JetBrainsMono Nerd Font',
       'Noto Sans Mono CJK JP' 
      }
      config.font_size = 13
      config.enable_wayland = false
      config.default_cursor_style = 'SteadyBar'
      ${optionalString config.homeModules.programs.shells.nu.enable "config.default_prog = { '${getExe config.programs.nushell.package}' }\n"}
      config.hide_tab_bar_if_only_one_tab = true
      config.integrated_title_button_style = 'Gnome'
      config.cursor_blink_rate = 0
      config.front_end = 'WebGpu'
      config.animation_fps = 60
      config.window_decorations = 'TITLE | RESIZE'
      config.term = 'wezterm'

      config.keys = {
        {
          key = 'r',
          mods = 'ALT',
          action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
        },
        {
          key = 'd',
          mods = 'ALT',
          action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
        },
      }

      config.window_frame = {
        font = wezterm.font 'Inter',
        font_size = 13
      }

      return config
    '';
  };
}
