final: prev:
{
  IDEmacs = prev.emacsPgtkGcc.overrideAttrs ( old: {
    buildInputs = with prev; old.buildInputs ++ [
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
  });
}
