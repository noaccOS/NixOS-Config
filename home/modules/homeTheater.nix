{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeModules.homeTheater;
  inherit (lib) mkEnableOption;

  kodi = pkgs.kodi-gbm;
in
{
  options.homeModules.homeTheater.enable = mkEnableOption "Home Theater with Kodi";

  config.programs.kodi = {
    enable = cfg.enable;
    package = kodi;
  };
}
