{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.gui;

  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.homeModules.gui.enable = mkEnableOption "gui programs";

  config = mkIf cfg.enable {
    homeModules.programs = {
      browsers.firefox.enable = true;
      browsers.firefox.defaultBrowser = mkDefault true;
      editors.vscode.enable = true;
      terminals.alacritty.enable = true;
      terminals.kitty.enable = true;
      terminals.rio.enable = true;
      video.mpv.enable = true;
    };

    # Fonts
    home.packages = with pkgs; [
      inter-nerdfont
      noto-fonts-cjk # Chinese, Japanese, Korean
      roboto
      joypixels
      symbola

      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    nixpkgs.config.joypixels.acceptLicense = true;

    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "JoyPixels" ];
        serif = [ "Inter Nerd Font" ];
        sansSerif = [ "Inter Nerd Font" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };
}
