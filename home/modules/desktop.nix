{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.homeModules.desktop;
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
  options.homeModules.desktop.enable = mkEnableOption "desktop programs";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      anytype
      rnote
    ];

    home.pointerCursor = {
      enable = true;
      name = "Breeze_Catppuccin";
      package = inputs.breeze-cursors-catppuccin.packages.${system}.default;
      x11.enable = true;
      gtk.enable = true;
    };

    homeModules.gui.enable = true;
    homeModules.development.extraEditors = [ "zed" ];
  };
}
