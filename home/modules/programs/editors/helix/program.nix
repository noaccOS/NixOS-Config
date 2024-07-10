{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (builtins) attrValues;
  inherit (lib)
    foldl'
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optional
    pipe
    recursiveUpdate
    types
    ;

  cfg = config.homeModules.programs.editors.helix;
  cfgDev = config.homeModules.development;

  defaultKeymap = pipe ./default-keymap.nix [
    import
    attrValues
    (foldl' recursiveUpdate { })
  ];

  keys.normal = defaultKeymap // {
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
  keys.select = defaultKeymap // {
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
in
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

      inherit keys;
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
          {
            name = "nu";
            formatter.command = pkgs.writeShellScript "nu-format-from-stdin" ''
              file=$(mktemp --suffix=.nu)
              cp /dev/stdin "$file"
              ${pkgs.nufmt}/bin/nufmt "$file"
              cat "$file"
            '';
          }
        ];
      })
    ]);
  };
}
