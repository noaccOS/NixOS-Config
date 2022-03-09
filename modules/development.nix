{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tree-sitter
    
    # Haskell
    ghc                       # Compiler
    haskell-language-server   # LSP
    haskellPackages.hindent   # Indent

    # Python
    python3                   # Compiler
    nodePackages.pyright      # LSP

    # C/C++
    clang                     # Compiler
    gcc                       # Compiler
    ccls                      # LSP

    # C#
    dotnet-sdk                # Compiler
    mono                      # Runner
    omnisharp-roslyn          # LSP

    # LaTeX
    texlab                    # LSP

    # Lua
    lua                       # Compiler

    # Rust
    rustc
    cargo

    # Racket
    racket                    # Compiler
      
    # Java
    jdk                       # Compiler
    # Not yet in the repos
    # jdtls                     # LSP
  ];
}
