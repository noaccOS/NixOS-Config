{ pkgs, config, lib, ... }:
let
  cfg = config.noaccOSModules.sway;
in
{
  options.noaccOSModules.sway = {
    enable = lib.mkEnableOption "Sway wayland compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        wl-clipboard
        alacritty
        dmenu
      ];
    };
  };
}
