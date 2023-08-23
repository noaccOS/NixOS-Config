{
  bat = {
    dracula = null;
    nord = null;
    catppuccin = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/bat/ba4d16880d63e656acced2b7d4e034e4a93f74b1/Catppuccin-mocha.tmTheme";
      sha256 = "1z434yxjq95bbfs9lrhcy2y234k34hhj5frwmgmni6j8cqj0vi58";
    };
  };

  wezterm = {
    dracula = {
      src = builtins.toFile "TrueDracula.toml" ''
        [colors]
        foreground = "#f8f8f2"
        background = "#282a36"
        cursor_bg = "#bd93f9"
        cursor_border = "#bd93f9"
        cursor_fg = "#282a36"
        selection_bg = "#44475a"
        selection_fg = "#f8f8f2"

        ansi = ["#000000","#ff5555","#50fa7b","#f1fa8c","#bd93f9","#ff79c6","#8be9fd","#bbbbbb"]
        brights = ["#555555","#ff5555","#50fa7b","#f1fa8c","#bd93f9","#ff79c6","#8be9fd","#ffffff"]
      '';
      dest = "TrueDracula.toml";
    };
    nord = { src = null; dest = null; };
    catppuccin = { src = null; dest = null; };
  };
}
