{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.homeModules.programs.editors.helix;
  cfgDev = config.homeModules.development;
  commonKeys = {
    space.space = "file_picker";
    space.f = ":format";
    space.p = "paste_clipboard_before";
    space.P = "paste_clipboard_after";
    l = "select_regex";
    L = "split_selection";
    p = "paste_before";
    P = "paste_after";
    "C-j" = "join_selections";
    "C-J" = "join_selections_space";
    "'" = "switch_to_lowercase";
    "\"" = "switch_to_uppercase";
    "C-'" = "switch_case";
    "C-w".r = "vsplit";
    "C-w".d = "hsplit";
    "C-w".t = "jump_view_down";
    "C-w".n = "jump_view_up";
    "C-w".s = "jump_view_right";
    "C-w".T = "swap_view_down";
    "C-w".N = "swap_view_up";
    "C-w".S = "swap_view_right";
    space.w.r = "vsplit";
    space.w.d = "hsplit";
    space.w.t = "jump_view_down";
    space.w.n = "jump_view_up";
    space.w.s = "jump_view_right";
    space.w.T = "swap_view_down";
    space.w.N = "swap_view_up";
    space.w.S = "swap_view_right";
    z.t = "scroll_down";
    z.n = "scroll_up";
    "C-k" = "keep_selections";
    "C-K" = "remove_selections";
    "`" = "select_register";
    "!" = "shell_append_output";
    "C-!" = "shell_insert_output";
    ";" = "command_mode";
    "." = "collapse_selection";
    "C-." = "flip_selections";
    "C-;" = "repeat_last_motion";
    # https://github.com/helix-editor/helix/issues/1488
    # ":" = "repeat_last_insert";
  };
in
with lib;
{
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
    visual = mkOption {
      type = types.str;
      readOnly = true;
      default = "hx";
      description = ''
        The string to use when setting helix as the default visual.
      '';
    };
  };

  config.programs.helix = {
    enable = cfg.enable;
    extraPackages = cfgDev.toolPackages ++ optional config.homeModules.gui.enable pkgs.wl-clipboard;
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
        completion-timeout = 5;
        line-number = "relative";
        lsp.display-messages = true;
        lsp.display-inlay-hints = true;
        file-picker.hidden = false;
        whitespace.render = {
          nbsp = "all";
          tab = "all";
        };
        rulers = [ 100 ];
        smart-tab.supersede-menu = true;
      };

      keys.normal = commonKeys // {
        t = "move_line_down";
        T = "move_visual_line_down";
        n = "move_line_up";
        N = "move_visual_line_up";
        s = "move_char_right";
        j = "find_till_char";
        J = "till_prev_char";
        k = "search_next";
        K = "search_prev";
        g.space = "goto_word";
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
        g.space = "extend_to_word";
        g.w = "extend_to_first_nonwhitespace";
        g.s = "extend_to_line_end";
      };
    };

    languages = mkIf cfgDev.enableTools (mkMerge [
      (mkIf cfgDev.elixir.enable {
        language-server.lexical.command = "${pkgs.lexical}/libexec/start_lexical.sh";
        language =
          map
            (name: {
              inherit name;
              language-servers = [ "lexical" ];
            })
            [
              "elixir"
              "heex"
            ];
      })
      (mkIf cfgDev.nix.enable {
        language-server.nixd.command = "${pkgs.nixd}/bin/nixd";
        language = [
          {
            name = "nix";
            language-servers = [ "nixd" ];
            formatter = {
              command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            };
          }
        ];
      })
    ]);
  };
}
