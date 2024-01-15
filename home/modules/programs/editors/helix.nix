{ pkgs, lib, config, ... }:
let cfg = config.homeModules.programs.editors.helix;
in with lib; {
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
    extraPackages = config.homeModules.development.toolPackages;
    settings = {
      editor = {
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
      keys.normal = {
        space.space = "file_picker";
        t = "move_line_down";
        T = "move_visual_line_down";
        n = "move_line_up";
        N = "move_visual_line_up";
        s = "move_char_right";
        j = "find_till_char";
        J = "till_prev_char";
        k = "search_next";
        K = "search_prev";
        l = "select_regex";
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
        g.w = "goto_first_nonwhitespace";
        g.s = "goto_line_end";
      };
    };
  };
}
