{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeModules.homeTheater;
  inherit (lib) getExe mkEnableOption mkIf;

  kodi = pkgs.kodi-wayland;
in
{
  options.homeModules.homeTheater.enable = mkEnableOption "Home Theater with Kodi";

  config = mkIf cfg.enable {
    programs.kodi = {
      enable = true;
      package = kodi;
    };

    programs.niri.settings.spawn-at-startup = [
      { argv = getExe kodi; }
    ];

  };
}
