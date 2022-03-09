{ config, pkgs, ... }:
{
  nixpkgs.overlays = [ (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";    
  }))
             ];
  
  programs = {
    wezterm = {
      enable = true;
      font = {
        family = [
          "JetBrainsMono Nerd Font"
          "JetBrains Mono"
          "Segoe UI Symbol"
          "Cambria"
          "JoyPixels"
        ];
        size = 12;
      };
      closePromptEnable = false;
      tabBarEnable = false;
      waylandEnable = false;
      padding = {
        left = 20;
        right = 20;
        top = 20;
        bottom = 20;
      };
    };

    mpv = {
      enable = true;
      config = {
        # Language
        alang = "jpn,ja,jp,eng,en"; # audio lang
        slang = "eng,en";           # sub   lang

        # 2x
        af    = "scaletempo2";
        speed = 2;

        # Subtitles
        sub-font = "Noto Sans";
        sub-font-size = 36;
        sub-color = "#FFFFFF";
        sub-border-color = "#131313";
        sub-border-size = 3.2;

        # Screenshots
        screenshot-format = "png";
        screenshot-directory = "~/Pictures/Screenshots/mpv";
      };
      
      bindings = {
        WHEEL_UP = "add volume 5";
        WHEEL_DOWN = "add volume -5";
        "{" = "add speed -.25";
        "}" = "add speed  .25";
        "[" = "add speed   -1";
        "]" = "add speed    1";
      };
    };

    emacs = {
      enable = true;
      package = pkgs.emacsPgtkGcc;
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

        tree-sitter
        tree-sitter-langs

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
      ];
    };
  };

  home.file = {
    ".emacs.d/init.el".source    = ../../config/emacs/init.el;
    ".emacs.d/README.org".source = ../../config/emacs/README.org;
  };
}
