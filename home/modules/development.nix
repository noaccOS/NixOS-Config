{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules.development;
  editorsCfg = config.homeModules.programs.editors;
in
with lib;
{
  options.homeModules.development = {
    defaultEditor = mkOption {
      type = types.enum [
        "helix"
        "vscode"
      ];
      default = cfg.defaultVisual;
    };

    defaultVisual = mkOption {
      type = types.enum [
        "helix"
        "vscode"
      ];
    };

    enableTools = mkEnableOption "LSPs, DAPs and compilers";

    toolPackages = mkOption {
      type = types.listOf types.package;
      description = "Final list of packages to install";
      readOnly = true;
    };

    c.enable = mkEnableOption "C";
    cSharp.enable = mkEnableOption "C#";
    elixir.enable = mkEnableOption "Elixir" // {
      default = true;
    };
    haskell.enable = mkEnableOption "Haskell" // {
      default = true;
    };
    java.enable = mkEnableOption "Java";
    latex.enable = mkEnableOption "LaTeX";
    lua.enable = mkEnableOption "Lua";
    markdown.enable = mkEnableOption "Markdown" // {
      default = true;
    };
    nix.enable = mkEnableOption "Nix" // {
      default = true;
    };
    rust.enable = mkEnableOption "Rust" // {
      default = true;
    };
    python.enable = mkEnableOption "Python" // {
      default = true;
    };
    racket.enable = mkEnableOption "Racket";
    zig.enable = mkEnableOption "Zig" // {
      default = true;
    };
  };

  config = mkMerge [
    {
      homeModules.programs.editors.${cfg.defaultEditor}.enable = true;
      home.sessionVariables.EDITOR = editorsCfg.${cfg.defaultEditor}.editor;
    }
    {
      homeModules.programs.editors.${cfg.defaultVisual}.enable = true;
      home.sessionVariables.VISUAL = editorsCfg.${cfg.defaultVisual}.visual;
    }
    (mkIf cfg.enableTools {
      home.sessionVariables = {
        ERL_AFLAGS = "-kernel shell_history enabled";
      };

      programs.gh.enable = true;
      programs.gh-dash.enable = true;
    })
    {
      homeModules.development.toolPackages = optionals cfg.enableTools (
        with pkgs;
        [ (tree-sitter.withPlugins (_: tree-sitter.allGrammars)) ]
        ++ optionals cfg.c.enable [
          clang # Compiler
          gcc # Compiler
          ccls # LSP
        ]
        ++ optionals cfg.cSharp.enable [
          dotnet-sdk # Compiler
          dotnet-runtime # Runner
          mono # Runner
          omnisharp-roslyn # LSP
        ]
        ++ optionals cfg.elixir.enable [
          elixir # Compiler
          lexical # LSP
          erlang # Needed for escript
        ]
        ++ optionals cfg.haskell.enable [
          ghc # Compiler
          stack # CLI tool
          haskell-language-server # LSP
          haskellPackages.hindent # Indent
        ]
        ++ optionals cfg.java.enable [
          jdk # Compiler
          jdt-language-server # LSP
        ]
        ++ optionals cfg.latex.enable [
          texlab # LSP
          python3Packages.pygments # Minted support
          texlive.combined.scheme-small # Compiler and libraries
        ]
        ++ optionals cfg.lua.enable [
          lua # Compiler
        ]
        ++ optionals cfg.markdown.enable [
          markdown-oxide # LSP
        ]
        ++ optionals cfg.nix.enable [
          nixfmt-rfc-style # Formatter
          nixd # LSP
        ]
        ++ optionals cfg.rust.enable [
          rustc # Compiler
          cargo # Project Manager
          rust-analyzer # LSP
          rustfmt # Formatter
        ]
        ++ optionals cfg.python.enable [
          python3 # Compiler
          pyright # LSP
        ]
        ++ optionals cfg.racket.enable [
          racket # Compiler
        ]
        ++ optionals cfg.zig.enable [
          zig # Compiler
          zls # LSP
        ]
      );
    }
  ];
}
