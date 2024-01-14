{ pkgs, config, lib, ... }:
let cfg = config.homeModules.development;
in with lib; {
  options.homeModules.development = {
    enableTools = mkEnableOption "LSPs, DAPs and compilers";

    toolPackages = mkOption {
      type = types.listOf types.package;
      description = "Final list of packages to install";
      readOnly = true;
    };

    c.enable = mkEnableOption "C";
    cSharp.enable = mkEnableOption "C#";
    elixir.enable = mkEnableOption "Elixir" // { default = true; };
    haskell.enable = mkEnableOption "Haskell" // { default = true; };
    java.enable = mkEnableOption "Java";
    latex.enable = mkEnableOption "LaTeX";
    lua.enable = mkEnableOption "Lua";
    markdown.enable = mkEnableOption "Markdown" // { default = true; };
    nix.enable = mkEnableOption "Nix" // { default = true; };
    rust.enable = mkEnableOption "Rust" // { default = true; };
    python.enable = mkEnableOption "Python" // { default = true; };
    racket.enable = mkEnableOption "Racket";
  };

  config = mkMerge [
    (mkIf cfg.enableTools {
      home.sessionVariables = {
        ERL_AFLAGS = "-kernel shell_history enabled";
      };
    })
    {
      homeModules.development.toolPackages = optionals cfg.enableTools (with pkgs; [
        (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
      ]
      ++ lib.optionals cfg.c.enable [
        clang # Compiler
        gcc # Compiler
        ccls # LSP
      ]
      ++ lib.optionals cfg.cSharp.enable [
        dotnet-sdk # Compiler
        dotnet-runtime # Runner
        mono # Runner
        omnisharp-roslyn # LSP
      ]
      ++ lib.optionals cfg.elixir.enable [
        elixir # Compiler
        elixir_ls # LSP
        erlang # Needed for escript
      ]
      ++ lib.optionals cfg.haskell.enable [
        ghc # Compiler
        stack # CLI tool
        haskell-language-server # LSP
        haskellPackages.hindent # Indent
      ]
      ++ lib.optionals cfg.java.enable [
        jdk # Compiler
        jdt-language-server # LSP
      ]
      ++ lib.optionals cfg.latex.enable [
        texlab # LSP
        python3Packages.pygments # Minted support
        texlive.combined.scheme-small # Compiler and libraries
      ]
      ++ lib.optionals cfg.lua.enable [
        lua # Compiler
      ]
      ++ lib.optionals cfg.markdown.enable [
        marksman # LSP
      ]
      ++ lib.optionals cfg.nix.enable [
        nixpkgs-fmt # Formatter
        nil # LSP
      ]
      ++ lib.optionals cfg.rust.enable [
        rustc # Compiler
        cargo # Project Manager
        rust-analyzer # LSP
        rustfmt # Formatter
      ]
      ++ lib.optionals cfg.python.enable [
        python3 # Compiler
        nodePackages.pyright # LSP
      ]
      ++ lib.optionals cfg.racket.enable [
        racket # Compiler
      ]);
    }
  ];

}
