{ config, pkgs, ... }:
let
  aliases = {
    defaults = {
      exa = "${pkgs.exa}/bin/exa --color=always --icons -a";
    };
    
    exa = {
      ls = "${aliases.defaults.exa}";
      ll = "${aliases.defaults.exa} -l";
      lt = "${aliases.defaults.exa} --tree";
    };
  };
in

{
  home.packages = [
    pkgs.ripgrep
    pkgs.neofetch
  ];
  
  programs = {
    bat = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    exa = {
      enable = true;
      # enableAliases = true; # I'm probably doing my own aliases
    };

    fish = {
      enable = true;
      shellAliases = aliases.exa;

      interactiveShellInit = ''
        set term (basename "/"(ps -f -p (cat /proc/(echo %self)/stat | cut -d \  -f 4) | tail -1 | sed 's/^.* //'))

        switch $term
          case kitty
            neofetch --config ~/.config/neofetch/config-kitty.conf
	        case wezterm-gui
	          neofetch --config ~/.config/neofetch/config-wezterm.conf
	        case '*'
            neofetch --config ~/.config/neofetch/config-others.conf
        end
      '';
    };

    neovim = {
      enable   = true;
      viAlias  = true;
      vimAlias = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
