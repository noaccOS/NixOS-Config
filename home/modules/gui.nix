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
    default = with pkgs; [
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
          "JetBrainsMono Nerd Font"
          "Noto Sans Mono CJK JP"
        ];
      };
    };
  };
}
