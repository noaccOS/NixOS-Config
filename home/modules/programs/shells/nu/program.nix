{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeModules.programs.shells.nu;
  inherit (lib)
    mkEnableOption
    mkIf
    optionalString
    ;

  inherit (lib.hm.nushell) mkNushellInline;

  # reedline hard-codes the helix keys with no matching table entry: `g` targets, `t`/`T` till
  # and any key following a count never reach the keybindings, so those are patched instead
  nushell-package = pkgs.nushell.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      patch -d "$cargoDepsCopy"/source-registry-0/reedline-* -p1 < ${./reedline-helix-custom-binds.patch}
    '';
    doCheck = false;
  });

  normal = "helix_normal";
  select = "helix_select";
  insert = "helix_insert";

  bind = name: mode: modifier: keycode: event: {
    inherit
      name
      mode
      modifier
      keycode
      event
      ;
  };

  keybindings = [
    # Movement
    (bind "hx_home" [ normal ] "none" "home" { edit = "MoveToLineNonBlankStart"; })
    (bind "hx_home_select" [ select ] "none" "home" {
      edit = "MoveToLineNonBlankStart";
      select = true;
    })
    (bind "hx_menu_next" [ normal insert ] "control" "char_t" {
      until = [
        { send = "MenuDown"; }
        { send = "Down"; }
      ];
    })
    (bind "hx_menu_prev" [ normal insert ] "control" "char_n" {
      until = [
        { send = "MenuUp"; }
        { send = "Up"; }
      ];
    })

    # Changes
    (bind "hx_lowercase" [ normal select ] "none" "char_'" { edit = "LowercaseSelection"; })
    (bind "hx_uppercase" [ normal select ] "none" "char_\"" { edit = "UppercaseSelection"; })
    (bind "hx_switch_case" [ normal select ] "control" "char_'" { edit = "SwitchcaseSelection"; })
    # select_register does not exist here; drop the builtin lowercase
    (bind "hx_no_register" [ normal select ] "none" "char_`" { send = "None"; })
    (bind "hx_earlier" [ normal select ] "control" "char_u" { edit = "Undo"; })
    (bind "hx_later" [ normal select ] "control_shift" "char_u" { edit = "Redo"; })
    (bind "hx_delete_word_backward" [ normal select ] "control" "backspace" {
      edit = "BackspaceWord";
    })
    (bind "hx_delete_word_forward" [ normal select ] "control" "delete" { edit = "DeleteWord"; })

    # Selection
    # Esc drops the selection onto its head, Select restores the resting one-cell selection.
    # CollapseSelection would jump past the selection instead
    (bind "hx_collapse_selection" [ normal select ] "none" "char_." [
      { send = "Esc"; }
      {
        edit = "Select";
        motion = "grapheme";
        direction = "forward";
      }
    ])
    (bind "hx_flip_selections" [ normal select ] "control" "char_." {
      edit = "SwapCursorAndAnchor";
    })
  ];
in
{
  options.homeModules.programs.shells.nu = {
    enable = mkEnableOption "nushell";
  };
  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      package = nushell-package;
      loadSessionVariables = true;
      settings = {
        inherit keybindings;
        edit_mode = "helix";
        buffer_editor = mkNushellInline "$env.VISUAL | split row ' '";
        show_banner = false;
        rm.always_trash = true;
        completions.algorithm = "fuzzy";
        filesize.unit = "binary";
        cursor_shape = {
          helix_insert = "line";
          helix_normal = "block";
          helix_select = "underscore";
        };
        use_kitty_protocol = true;
        menus = [
          {
            name = "completion_menu";
            only_buffer_difference = false;
            # this whole config is needed just to change the marker here. why is this not a record?
            marker = "";
            type = {
              layout = "columnar";
              columns = 4;
              col_width = 20;
              col_padding = 2;
              tab_traversal = "horizontal";
            };
            style = {
              text = "green";
              selected_text = "green_reverse";
              description_text = "yellow";
            };
          }
        ];
      };
      configFile.source = ./config.nu;
      extraConfig = optionalString config.programs.starship.enable ''
        $env.TRANSIENT_PROMPT_COMMAND = ^starship module character
        $env.TRANSIENT_PROMPT_COMMAND_RIGHT = ^starship module time
        # helix mode shows the vi indicators after starship's character; the cursor shape already
        # tells the mode apart
        $env.PROMPT_INDICATOR_VI_INSERT = ""
        $env.PROMPT_INDICATOR_VI_NORMAL = ""
      '';
    };

    # It always shows a job under nushell, while not providing much value
    programs.starship.settings.jobs.disabled = true;
  };
}
