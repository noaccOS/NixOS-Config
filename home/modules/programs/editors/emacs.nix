{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.programs.editors.emacs;
in
{
  options.homeModules.programs.editors.emacs = {
    enable = lib.mkEnableOption "Emacs";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.emacs-gtk;
      description = "Emacs package to install";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = cfg.package;
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
      ".emacs.d/init.el".source = ../../../config/emacs/init.el;
      ".emacs.d/README.org".source = ../../../config/emacs/README.org;
    };
  };
}
