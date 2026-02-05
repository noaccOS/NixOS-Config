{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeModules.programs.editors.zed;
  cfgDev = config.homeModules.development;
  zed-exe = lib.getExe config.programs.zed-editor.package;

  inherit (lib)
    flatten
    flip
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    pipe
    types
    ;

  all-language-extensions = {
    c = [ ];
    cSharp = [ "csharp" ];
    elixir = [
      "elixir"
      "elixir-snippets"
    ];
    haskell = [ "haskell" ];
    java = [ "java" ];
    latex = [ "latex" ];
    lua = [ "lua" ];
    markdown = [ "markdown-oxide" ];
    nu = [
      "nu"
      "nu-lint"
    ];
    nix = [ "nix" ];
    rust = [ "rust-snippets" ];
    python = [ ];
    racket = [ "racket" ];
    typescript = [
      "html"
      "scss"
      "json5"
    ];
    typst = [ "typst" ];
    yaml = [ ];
    zig = [ "zig" ];
  };

  language-extensions = pipe all-language-extensions [
    (mapAttrsToList (lang: extensions: if cfgDev.${lang}.enable then extensions else [ ]))
    flatten
  ];

  default-language-extensions = [
    "docker-compose"
    "dockerfile"
    "dprint"
    "fish"
    "gleam"
    "jj-lsp"
    "jq"
    "just"
    "kdl"
    "org"
    "toml"
  ];

  other-extensions = [ ];

  extensions = language-extensions ++ default-language-extensions ++ other-extensions;
in
{
  options.homeModules.programs.editors.zed = {
    enable = mkEnableOption "zed";
    editor = mkOption {
      type = types.str;
      readOnly = true;
      default = "${zed-exe} --wait";
      description = ''
        The string to use when setting zed as the default editor.
      '';
    };
    visual = mkOption {
      type = types.str;
      readOnly = true;
      default = "${zed-exe} --wait";
      description = ''
        The string to use when setting zed as the default visual.
      '';
    };
    desktopFile = mkOption {
      type = types.str;
      readOnly = true;
      default = "dev.zed.Zed.desktop";
      description = "Desktop file name. Used for xdg default applications";
    };
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;

      package = pkgs.zed-editor-fhs;
      extensions = extensions;
      extraPackages = cfgDev.toolPackages;
      userKeymaps = { };
      mutableUserKeymaps = false;
      userSettings = {
        cursor_blink = false;
        buffer_font_family = "Nosevka Nerd Font";
        ui_font_family = "Atkinson Hyperlegible Next";
        ui_font_size = 16;
        buffer_font_size = 16;
        disable_ai = true;
        tab_bar = {
          show = false;
        };
        go_to_definition_fallback = "none";
        inlay_hints = {
          enabled = true;
        };
        use_auto_surround = false;
        preferred_line_length = 100;
        soft_wrap = "editor_width";
        sticky_scroll = {
          enabled = true;
        };
        which_key = {
          enabled = true;
          delay_ms = 0;
        };
        autosave = "on_focus_change";
        base_keymap = "VSCode";
        vim_mode = false;
        helix_mode = true;
        buffer_line_height = "standard";
        auto_update = false;
        restore_on_startup = "launchpad";
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
      };
    };

    xdg.configFile."zed/keymap.json".source = ./keymap.jsonc;
  };
}
