{
  movement = {
    # https://github.com/helix-editor/helix/issues/1488
    # ":" = "repeat_last_insert";
    "C-;" = "repeat_last_motion";
    "C-b" = "page_cursor_half_up";
    "C-f" = "page_cursor_half_down";
  };
  changes = {
    p = "paste_before";
    P = "paste_after";
    "`" = "select_register";
    "'" = "switch_to_lowercase";
    "\"" = "switch_to_uppercase";
    "C-'" = "switch_case";
    "C-backspace" = "delete_word_backward";
    "C-del" = "delete_word_forward";
    "C-u" = "earlier";
    "C-U" = "later";
  };
  shell = {
    "!" = "shell_append_output";
    "C-!" = "shell_insert_output";
    "C-|" = "shell_pipe_to";
  };
  selection = {
    l = "select_regex";
    L = "split_selection";
    Y = "yank_joined";
    "." = "collapse_selection";
    "C-." = "flip_selections";
    "C-minus" = "merge_selections";
    "C-_" = "merge_consecutive_selections";
    "C-," = "remove_primary_selection";
    "C-(" = "rotate_selection_contents_backward";
    "C-)" = "rotate_selection_contents_forward";
    "C-C" = "copy_selection_on_prev_line";
    "C-e" = "expand_selection";
    "C-E" = "shrink_selection";
    "C-j" = "join_selections";
    "C-J" = "join_selections_space";
    "C-k" = "keep_selections";
    "C-K" = "remove_selections";
    "C-n" = "select_next_sibling";
    "C-N" = "select_prev_sibling";
    "C-s" = "split_selection_on_newline";
    "C-x" = "shrink_to_line_bounds";
  };
  search = { };
  minor = {
    ";" = "command_mode";
  };
  view.z = {
    t = "scroll_down";
    n = "scroll_up";
  };
  goto = { };
  match = { };
  window.space.w = {
    r = "vsplit";
    d = "hsplit";
    t = "jump_view_down";
    n = "jump_view_up";
    s = "jump_view_right";
    T = "swap_view_down";
    N = "swap_view_up";
    S = "swap_view_right";
  };
  space.space = {
    space = "file_picker";
    Y = "yank_joined_to_clipboard";
    f = ":format";
    p = "paste_clipboard_before";
    P = "paste_clipboard_after";
    "C-c" = "toggle_line_comments";
  };
  popup = { };
  unimpaired = { };
  insert = { };
}
