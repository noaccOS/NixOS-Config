{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}:
let
  cfg = config.homeModules.gui;

  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.homeModules.gui.enable = mkEnableOption "gui programs";
  options.homeModules.gui.fontPackages = mkOption {
    type = with types; listOf package;
    description = "Font packages";
    readOnly = true;
    default =
      let
        iosevka-noaccos = pkgs.iosevka.override {
          set = "noaccos";
          privateBuildPlan = {
            exportGlyphNames = true;
            family = "Iosevka-NoaccOS";
            ligations.inherits = "dlig";
            noCvSs = false;
            serifs = "sans";
            spacing = "normal";
            variants = {
              # JetBrains Mono
              inherits = "ss14";
              design = {
                a = "double-storey-serifed";
                at = "threefold";
                b = "toothless-rounded-serifless";
                capital-x = "straight-bilateral-motion-serifed";
                dollar = "slanted-interrupted";
                f = "tailed";
                g = "double-storey-open";
                i = "tailed-serifed";
                micro-sign = "tailed-serifed";
                n = "earless-corner-tailed-serifless";
                p = "earless-corner-serifless";
                q = "earless-corner-diagonal-tailed-serifless";
                x = "semi-chancery-straight-serifless";
              };
            };
            widths = {
              Condensed = {
                css = "condensed";
                menu = 3;
                shape = 456;
              };
              Extended = {
                css = "expanded";
                menu = 7;
                shape = 720;
              };
              Normal = {
                css = "normal";
                menu = 5;
                shape = 600;
              };
              SemiCondensed = {
                css = "semi-condensed";
                menu = 4;
                shape = 548;
              };
              SemiExtended = {
                css = "semi-expanded";
                menu = 6;
                shape = 658;
              };
            };
          };
        };
      in
      with pkgs;
      [
        iosevka-noaccos
        inter-nerdfont
        joypixels
        nerd-fonts.jetbrains-mono
        noto-fonts-cjk-sans # Chinese, Japanese, Korean
        roboto
        symbola
      ];
  };

  config = mkIf cfg.enable {
    homeModules.programs = {
      browsers.firefox.enable = true;
      browsers.firefox.defaultBrowser = mkDefault true;
      editors.vscode.enable = true;
      terminals.alacritty.enable = true;
      terminals.ghostty.enable = true;
      video.mpv.enable = true;
    };

    home.packages = cfg.fontPackages;
    nixpkgs.config.joypixels.acceptLicense = true;

    home.pointerCursor = {
      enable = true;
      name = "Breeze_Catppuccin";
      package = inputs.breeze-cursors-catppuccin.packages.${system}.default;
      x11.enable = true;
      gtk.enable = true;
    };

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "JoyPixels" ];
        serif = [
          "Inter Nerd Font"
          "Noto Sans CJK JP"
        ];
        sansSerif = [
          "Inter Nerd Font"
          "Noto Sans CJK JP"
        ];
        monospace = [
          "Iosevka-NoaccOS"
          "Noto Sans Mono CJK JP"
        ];
      };
    };
  };
}
