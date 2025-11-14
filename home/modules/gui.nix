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
      atkinson-hyperlegible-next
      inter-nerdfont
      inputs.nosevka.packages.${system}.complete
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

    catppuccin.gtk.icon.enable = false;

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "JoyPixels" ];
        serif = [
          "Atkinson Hyperlegible Next"
          "Noto Sans CJK JP"
        ];
        sansSerif = [
          "Atkinson Hyperlegible Next"
          "Noto Sans CJK JP"
        ];
        monospace = [
          "Nosevka NF"
          "Noto Sans Mono CJK JP"
        ];
      };
    };
  };
}
