{ pkgs, lib, config, ... }:
let
  cfg = config.homeModules.programs.editors.helix;
  commonKeys = {
    l = "select_regex";
    L = "split_selection";
    p = "paste_before";
    P = "paste_after";
    o = "open_above";
    O = "open_below";
    "'" = "switch_to_lowercase";
    "\"" = "switch_to_uppercase";
    "C-'" = "switch_case";
    "`" = "select_register";
    "!" = "shell_append_output";
    "A-!" = "shell_insert_output";
  };
in
with lib; {
  options.homeModules.programs.editors.helix = {
    enable = mkEnableOption "helix";
    editor = mkOption {
      type = types.str;
      readOnly = true;
      default = "hx";
      description = ''
        The string to use when setting helix as the default editor.
      '';
    };
  };

  config.programs.helix = {
    enable = cfg.enable;
    extraPackages = config.homeModules.development.toolPackages
      ++ optional config.homeModules.gui.enable pkgs.wl-clipboard;
    settings = {
      editor = {
        auto-save = true;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides = {
          render = true;
          skip-levels = 2;
        };
        idle-timeout = 0;
        line-number = "relative";
        lsp.display-messages = true;
        file-picker.hidden = false;
        whitespace.render = {
          nbsp = "all";
          tab = "all";
        };
        rulers = [ 100 ];
        smart-tab.supersede-menu = true;
      };

      keys.normal = commonKeys // {
        space.space = "file_picker";
        space.p = "paste_clipboard_before";
        space.P = "paste_clipboard_after";
        t = "move_line_down";
        T = "move_visual_line_down";
        n = "move_line_up";
        N = "move_visual_line_up";
        s = "move_char_right";
        j = "find_till_char";
        J = "till_prev_char";
        k = "search_next";
        K = "search_prev";
        g.w = "goto_first_nonwhitespace";
        g.s = "goto_line_end";
      };

      keys.select = commonKeys // {
        t = "extend_line_down";
        T = "extend_visual_line_down";
        n = "extend_line_up";
        N = "extend_visual_line_up";
        s = "extend_char_right";
        j = "extend_till_char";
        J = "extend_till_prev_char";
        k = "extend_search_next";
        K = "extend_search_prev";
        g.w = "extend_to_first_nonwhitespace";
        g.s = "extend_to_line_end";
      };
    };
  };
}
