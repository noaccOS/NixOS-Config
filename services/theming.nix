{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.services.theming;
  usegradience = cfg.theme.useGradience;
  
  themingPackages = with pkgs; {
      all        = [ dracula-theme nordic catppuccin-gtk ];
      dracula    = [ dracula-theme ];
      nord       = [ nordic ];
      catppuccin = [ catppuccin-gtk ];
  };

  overlays = [
    (self: super:
      {
        papirus-folders = super.papirus-folders.overrideAttrs (old: {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo  = "papirus-folders";
            rev   = "7aefd7a20c63a5e167745d5bd6d297c5f7ce747d";
            sha256 = "0pma0yzjb5m4m22f329b74nws50ij1c5pz19a6cgb9p2f3k1dmmi";
          };
        });
      })
  ];

  iconPackages = with pkgs; {
    all = [
      papirus-icon-theme
      numix-icon-theme
      zafiro-icons
      tela-circle-icon-theme
    ];
    
    papirus = [ papirus-icon-theme ];
    numix   = [ numix-icon-theme ];
    zafiro  = [ zafiro-icons ];
    tela    = [ tela-circle-icon-theme ];
  };
in
{
  options.services.theming = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable noaccOS' theming engine for NixOS
      '';
    };

    theme = {
      defaultTheme = mkOption {
        type = types.enum [ "dracula" "nord" "catppuccin" ];
        default = "catppuccin";
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

      useGradience = mkOption {
        type = types.bool;
        default = config.services.xserver.desktopManager.gnome.enable;
        description = "Use adw3-gtk with gradience instead";
      };
    };

    icons = {
      defaultTheme = mkOption {
        type = types.enum [ "papirus" "numix" "zafiro" "simple" "tela" ];
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
      if cfg.theme.useGradience then
        [ # pkgs.gradience ## wait for https://github.com/NixOS/nixpkgs/pull/189542
          pkgs.adw-gtk3
        ]
      else
        themingPackages.${cfg.theme.defaultTheme}
      ++ iconPackages.${cfg.icons.defaultTheme}

      ++ optionals cfg.theme.installAll themingPackages.all
      ++ optionals cfg.icons.installAll    iconPackages.all
        
      ++ optionals cfg.themingTools [
        pkgs.themechanger
        pkgs.libsForQt5.qtstyleplugin-kvantum # just testing
      ];

    environment.variables.QT_STYLE_OVERRIDE = "kvantum";
    
    qt.enable = false;
    
    environment.etc =
      let
        gtk-themes  = { dracula = "Dracula"; nord = "Nordic-darker"; catppuccin = "Catppuccin"; };
        icon-themes = {
          papirus = "Papirus-Dark";
          numix   = "Numix-Circle";
          zafiro  = "Zafiro-icons";
          tela    = "Tela-circle-purple-dark";
        };
        gtk4css = {
          dracula = fetchurl{
            url = "https://raw.githubusercontent.com/dracula/gtk/58b8cf7f5d4099a644df322942549b26474faa04/gtk-4.0/gtk.css";
            sha256 = "1ivnsz342iql4rbl995wzgniqk403vxwjjssvspdbd8qn3lnmlwn";
          };
          nord = fetchurl {
            url = "https://raw.githubusercontent.com/EliverLara/Nordic/1ec58be81b2e472abaf1894753439af6884e48b4/gtk-4.0/gtk-dark.css";
            sha256 = "1irsx0y55gvlk8hdqc5v35czg6hq2v8mcck00fpkzpgr3ccpf40x";
          };
          catppuccin = fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/gtk/7bfea1f0d569010998302c8242bb857ed8a83058/src/main/gtk-4.0/gtk-dark.css";
            sha256 = "077pihczqj5w7bhj0jzlf9mrvw1yd3d3dry0vlccjnmkrjm57vi1";
          };
        };

        defGtk = if cfg.theme.useGradience
                 then "adw-gtk3-dark"
                 else gtk-themes.${cfg.theme.defaultTheme};
        defIcn = icon-themes.${cfg.icons.defaultTheme};
        defCss = gtk4css.${cfg.theme.defaultTheme};
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
      "gtk-4.0/gtk.css".source = defCss;
    };
  };  
}
