{
  pkgs,
  lib,
  config,
  inputs,
  system,
  ...
}:
let
  inherit (builtins)
    attrValues
    listToAttrs
    mapAttrs
    typeOf
    ;
  inherit (lib)
    elemAt
    foldl'
    getExe
    mkEnableOption
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
    desktopFile = mkOption {
      type = types.str;
      readOnly = true;
      default = "Helix.desktop";
      description = "Desktop file name. Used for xdg default applications";
    };
  };

  config.programs.helix = {
    enable = cfg.enable;
    package = inputs.helix.packages.${system}.default;
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
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "error";
        };
        completion-timeout = 5;
        completion-trigger-len = 1;
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

    languages =
      let
        mkIf = condition: attrs: if condition then attrs else { };
        mkMerge = foldl' recursiveUpdate { };
        prettierFmt' = hxlang: prettierlang: {
          name = hxlang;
          formatter.command = getExe pkgs.nodePackages_latest.prettier;
          formatter.args = [
            "--parser"
            prettierlang
          ];
        };
        prettierFmt = lang: prettierFmt' lang lang;
        language_config = mkMerge [
          (mkIf cfgDev.elixir.enable {
            language-server.lexical.command = "${pkgs.lexical}/libexec/start_lexical.sh";
            language-server.nextls = {
              command = getExe pkgs.next-ls;
              args = [ "--stdio" ];
              config.experimental.completions.enable = true;
            };
            language =
              let
                languages = [
                  "elixir"
                  "heex"
                ];
              in
              pipe languages [
                (map (lang: {
                  name = lang;
                  value.scope = "source.elixir";
                  value.language-servers = [ "lexical" ];
                }))
                listToAttrs
              ];
          })
          (mkIf cfgDev.nix.enable {
            language-server.nixd.command = getExe pkgs.nixd;
            language.nix = {
              language-servers = [ "nixd" ];
              formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            };
          })
          (mkIf cfgDev.markdown.enable {
            language.markdown.language-servers = [ "markdown-oxide" ];
          })
          {
            # prettier
            language =
              let
                languages = [
                  "html"
                  "css"
                  [
                    "javascript"
                    "typescript"
                  ]
                  "typescript"
                  [
                    "tsx"
                    "typescript"
                  ]
                  "json"
                  "json5"
                  "yaml"
                  "markdown"
                ];
              in
              pipe languages [
                (map (
                  language:
                  let
                    config =
                      {
                        string = prettierFmt language;
                        list =
                          let
                            hxlang = elemAt language 0;
                            prettierlang = elemAt language 1;
                          in
                          prettierFmt' hxlang prettierlang;
                      }
                      .${typeOf language};
                  in
                  {
                    name = config.name;
                    value = config;
                  }
                ))
                listToAttrs
              ];
          }
          {
            # formatter only
            language.haskell.formatter.command = getExe pkgs.stylish-haskell;
          }
        ];
      in
      mkIf cfgDev.enableTools (
        let
          language-server = language_config.language-server;
          language = pipe language_config.language [
            (mapAttrs (name: value: value // { inherit name; }))
            attrValues
          ];
        in
        {
          inherit language language-server;
        }
      );
  };
}
