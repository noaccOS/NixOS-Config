{ pkgs, ... }:
let
  myPython = pkgs.python3.withPackages (py: [
    py.requests
    py.pygobject3
    py.gst-python
  ]);
in
{
  environment.systemPackages = with pkgs; [
    (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
    
    # Haskell
    ghc                       # Compiler
    stack                     # CLI tool
    haskell-language-server   # LSP
    haskellPackages.hindent   # Indent

    # Python
    myPython                  # Compiler
    nodePackages.pyright      # LSP

    # C/C++
    clang                     # Compiler
    gcc                       # Compiler
    ccls                      # LSP

    # C#
    dotnet-sdk                # Compiler
    dotnet-runtime            # Runner
    mono                      # Runner
    omnisharp-roslyn          # LSP

    # LaTeX
    texlab                        # LSP
    python3Packages.pygments      # Minted support
    texlive.combined.scheme-small # Compiler and libraries

    # Lua
    lua                       # Compiler

    # Rust
    rustc
    cargo
    rust-analyzer             # LSP
    rustfmt                   # Formatter

    # Racket
    racket                    # Compiler
      
    # Java
    jdk                       # Compiler
    jdt-language-server       # LSP

    # Elixir
    elixir                    # Compiler
    elixir_ls                 # LSP
    erlang                    # Needed for escript

    (aspellWithDicts (ps: with ps; [ en it ]))
  ];

  services = {
    postgresql.enable = true;
  };
}
