{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.personal;

  inherit (lib) mkMerge mkEnableOption mkIf;
in
{
  options.homeModules.personal.enable = mkEnableOption "personal programs";

  config = mkIf cfg.enable (mkMerge [
    (mkIf config.homeModules.gui.enable {
      home.packages = with pkgs; [
        telegram-desktop
        anki-bin
      ];
    })
  ]);
}
