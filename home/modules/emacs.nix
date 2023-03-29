{ pkgs, emacsPkg ? pkgs.emacs-gtk, ... }:
{
  programs.emacs = {
      enable = true;
      package = emacsPkg;
      extraPackages = epkgs: with epkgs; [
        doom-themes
        doom-modeline

        rainbow-delimiters
        multiple-cursors
        avy
        undo-tree
        which-key
        ace-window
        wrap-region
        magit
        ace-popup-menu
        diff-hl
        flycheck
        vterm
        org-superstar
        company
        elcord

        lsp-mode
        lsp-ui
        # company-lsp
        lsp-treemacs
        lsp-ivy
        lsp-origami
        dap-mode

        lsp-pyright
        lsp-haskell
        hindent
        ccls
        lsp-java
        fish-mode
        lua-mode
        lsp-latex
        nix-mode
        nixos-options
        company-nixos-options
        rustic

        tree-sitter
        tree-sitter-langs
        tree-sitter-indent

        elfeed
        elfeed-dashboard
        
        treemacs
        treemacs-icons-dired
        treemacs-magit
        
        counsel
        ivy-rich
        all-the-icons-ivy
        ivy-avy

        dired-rsync
        diredfl
        all-the-icons-dired

        pdf-tools
      ];
  };

  home.file = {
    ".emacs.d/init.el".source    = ../../config/emacs/init.el;
    ".emacs.d/README.org".source = ../../config/emacs/README.org;
  };
}
