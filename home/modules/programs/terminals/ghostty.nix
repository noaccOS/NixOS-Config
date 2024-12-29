{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.homeModules.programs.terminals.alacritty;

  inherit (lib) mkEnableOption mkIf;

  ghostty-config = ''
    theme = catppuccin-mocha
    window-theme = ghostty
    font-size = 14
    clipboard-paste-protection = false
    shell-integration-features = no-cursor
    cursor-style = bar
    cursor-style-blink = false
    unfocused-split-opacity = 0.85

    keybind = clear
    keybind = alt+y=copy_to_clipboard
    keybind = alt+p=paste_from_clipboard
    keybind = alt+r=new_split:right
    keybind = alt+d=new_split:down
    keybind = alt+h=goto_split:left
    keybind = alt+t=goto_split:bottom
    keybind = alt+n=goto_split:top
    keybind = alt+s=goto_split:right
    keybind = alt+m=resize_split:left,10
    keybind = alt+w=resize_split:down,10
    keybind = alt+v=resize_split:up,10
    keybind = alt+z=resize_split:right,10
    keybind = alt+f=toggle_split_zoom
    keybind = alt+e=equalize_splits
    keybind = alt+s=write_scrollback_file:open
    keybind = alt+u>n=new_window
    keybind = alt+u>t=new_tab
    keybind = alt+u>q=close_surface
    keybind = alt+u>r=reload_config
  '';
in
{
  options.homeModules.programs.terminals.ghostty = {
    enable = mkEnableOption "ghostty";
  };

  config = mkIf (cfg.enable) {
    home.packages = [ inputs.ghostty.packages.${pkgs.system}.default ];

    xdg.configFile."ghostty/config".text = ghostty-config;
  };
}
