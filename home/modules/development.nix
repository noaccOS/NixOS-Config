{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules.development;
  editorsCfg = config.homeModules.programs.editors;

  inherit (builtins) attrValues;
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optionals
    types
    ;
in
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
        [ (pkgs.tree-sitter.withPlugins (_: pkgs.tree-sitter.allGrammars)) ]
        ++ optionals cfg.c.enable (attrValues {
          inherit (pkgs)
            clang # Compiler
            gcc # Compiler
            ccls # LSP
            ;
        })
        ++ optionals cfg.cSharp.enable (attrValues {
          inherit (pkgs)
            dotnet-sdk # Compiler
            dotnet-runtime # Runner
            mono # Runner
            omnisharp-roslyn # LSP
            ;
        })
        ++ optionals cfg.elixir.enable (attrValues {
          inherit (pkgs)
            elixir # Compiler
            lexical # LSP
            erlang # Needed for escript
            ;
        })
        ++ optionals cfg.haskell.enable (attrValues {
          inherit (pkgs)
            ghc # Compiler
            stack # CLI tool
            haskell-language-server # LSP
            ;

          inherit (pkgs.haskellPackages)
            hindent # Indent
            ;
        })
        ++ optionals cfg.java.enable (attrValues {
          inherit (pkgs)
            jdk # Compiler
            jdt-language-server # LSP
            ;
        })
        ++ optionals cfg.latex.enable (attrValues {
          inherit (pkgs)
            texlab # LSP
            ;

          inherit (pkgs.python3Packages)
            pygments # Minted support
            ;
          inherit (pkgs.texlive.combined)
            scheme-small # Compiler and libraries
            ;
        })
        ++ optionals cfg.lua.enable (attrValues {
          inherit (pkgs)
            lua # Compiler
            ;
        })
        ++ optionals cfg.markdown.enable (attrValues {
          inherit (pkgs)
            markdown-oxide # LSP
            ;

          inherit (pkgs.nodePackages_latest)
            prettier # Formatter
            ;
        })
        ++ optionals cfg.nix.enable (attrValues {
          inherit (pkgs)
            nixfmt-rfc-style # Formatter
            nixd # LSP
            ;
        })
        ++ optionals cfg.rust.enable (attrValues {
          inherit (pkgs)
            rustc # Compiler
            cargo # Project Manager
            rust-analyzer # LSP
            rustfmt # Formatter
            ;
        })
        ++ optionals cfg.python.enable (attrValues {
          inherit (pkgs)
            python3 # Compiler
            pyright # LSP
            ;
        })
        ++ optionals cfg.racket.enable (attrValues {
          inherit (pkgs)
            racket # Compiler
            ;
        })
        ++ optionals cfg.zig.enable (attrValues {
          inherit (pkgs)
            zig # Compiler
            zls # LSP
            ;
        })
      );
    }
  ];
}
