{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.homeModules.gui;
  system = pkgs.stdenv.hostPlatform.system;

  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.homeModules.gui.enable = mkEnableOption "gui components";
  options.homeModules.gui.fontPackages = mkOption {
    type = with types; listOf package;
    description = "Font packages";
    readOnly = true;
    default = with pkgs; [
      atkinson-hyperlegible-next
      inter-nerdfont
      inputs.nosevka.packages.${system}.complete
      openmoji-color
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans-static # Chinese, Japanese, Korean
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

    catppuccin.gtk.icon.enable = false;

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "OpenMoji Color" ];
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

    gtk.gtk4.theme = config.gtk.theme;
  };
}
