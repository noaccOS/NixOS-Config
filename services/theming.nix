{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.services.theming;
  
  themingPackages = with pkgs; {
      all     = [ dracula-theme nordic ];
      dracula = [ dracula-theme ];
      nord    = [ nordic ];
  };

  iconPackages = with pkgs; {
    all = [
      papirus-icon-theme
      numix-icon-theme
      zafiro-icons
    ];
    
    papirus = [ papirus-icon-theme ];
    numix   = [ numix-icon-theme ];
    zafiro  = [ zafiro-icons ];
  };
in
{
  options.services.theming = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Wether to enable noaccOS' theming engine for nixos
      '';
    };

    theme = {
      defaultTheme = mkOption {
        type = types.enum [ "dracula" "nord" ];
        default = "dracula";
        description = ''
          Default theme to set
        '';
      };

      installAll = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Install all themes, not just the default one
        '';
      };
    };

    icons = {
      defaultTheme = mkOption {
        type = types.enum [ "papirus" "numix" "zafiro" "simple" ];
        default = "papirus";
        description = ''
          Default icon theme to use
        '';
      };
      installAll = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Install all themes, not just the default one
        '';
      };
    };
    
    themingTools = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Installs packages to enable manual theming. Useful if something breaks
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      themingPackages.${cfg.theme.defaultTheme}
      ++ iconPackages.${cfg.icons.defaultTheme}

      ++ optionals cfg.theme.installAll themingPackages.all
      ++ optionals cfg.icons.installAll    iconPackages.all
        
      ++ optionals cfg.themingTools [
        pkgs.themechanger
        pkgs.libsForQt5.qtstyleplugin-kvantum # just testing
      ];

    environment.variables.QT_STYLE_OVERRIDE = "kvantum";
    
    qt5.enable = false;
    
    environment.etc =
      let
        gtk-themes  = { dracula = "Dracula"; nord = "Nordic-darker"; };
        icon-themes = {
          papirus = "Papirus-Dark";
          numix   = "Numix-Circle";
          zafiro  = "Zafiro-icons";
        };

        defGtk = gtk-themes.${cfg.theme.defaultTheme};
        defIcn = icon-themes.${cfg.icons.defaultTheme};
      in
      {
      "gtk-2.0/gtkrc".text = ''
        gtk-theme-name="${defGtk}"
        gtk-icon-theme-name="${defIcn}"
        gtk-cursor-theme-name="Breeze"
        gtk-font-name="Noto Sans,  10"
        gtk-menu-images=1
        gtk-cursor-theme-size=24
        gtk-button-images=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
        gtk-xft-dpi=98304
      '';
      "gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=${defGtk}
        gtk-icon-theme-name=${defIcn}
        # GTK3 ignores bold or italic attributes.
        gtk-font-name=Noto Sans,  10
        gtk-menu-images=1
        gtk-button-images=1
        gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
        gtk-cursor-theme-name=Breeze
        gtk-cursor-theme-size=0
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintslight
        gtk-xft-rgba=rgb
      '';
      "gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=${defGtk}
        gtk-application-prefer-dark-theme=false
        gtk-icon-theme-name=${defIcn}
        gtk-cursor-theme-name=Breeze
        gtk-cursor-theme-size=24
        gtk-font-name=Noto Sans,  10
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintslight
        gtk-xft-rgba=rgb
        gtk-xft-dpi=98304
        gtk-overlay-scrolling=true
      '';
    };
  };  
}
