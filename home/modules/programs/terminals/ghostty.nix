{
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules.programs.terminals.alacritty;

  inherit (lib) mkEnableOption;
in
{
  options.homeModules.programs.terminals.ghostty = {
    enable = mkEnableOption "ghostty";
  };

  config.programs.ghostty = {
    enable = cfg.enable;
    clearDefaultKeybinds = true;
    settings = {
      window-theme = "ghostty";
      window-decoration = "client";
      font-family = "Iosevka-NoaccOS";
      font-size = 14;
      clipboard-paste-protection = false;
      mouse-scroll-multiplier = 2.5;
      shell-integration-features = "no-cursor";
      cursor-style = "bar";
      cursor-style-blink = false;
      unfocused-split-opacity = 0.85;

      keybind = [
        "alt+y=copy_to_clipboard"
        "alt+p=paste_from_clipboard"
        "alt+r=new_split:right"
        "alt+d=new_split:down"
        "alt+h=goto_split:left"
        "alt+t=goto_split:bottom"
        "alt+n=goto_split:top"
        "alt+s=goto_split:right"
        "alt+m=resize_split:left,100"
        "alt+w=resize_split:down,100"
        "alt+v=resize_split:up,100"
        "alt+z=resize_split:right,100"
        "alt+f=toggle_split_zoom"
        "alt+e=equalize_splits"
        "alt+o=write_scrollback_file:open"
        "alt+u>n=new_window"
        "alt+u>t=new_tab"
        "alt+u>q=close_surface"
        "alt+u>r=reload_config"
        "alt+equal=increase_font_size:5"
        "alt+minus=decrease_font_size:5"
      ];
    };
  };
}
