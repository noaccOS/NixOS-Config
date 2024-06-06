{
  lib,
  config,
  pkgs,
  currentSystem,
  ...
}:
let
  cfg = config.noaccOSModules.gaming;
in
{
  options.noaccOSModules.gaming = {
    enable = lib.mkEnableOption "Various launchers and gaming drivers";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wineWowPackages.staging
      winetricks

      gamemode
      mangohud

      # polymc
      # prismlauncher
      lutris
      heroic
    ];

    hardware.xpadneo.enable = true;
    programs.steam.enable = true;

    services = {
      input-remapper = {
        enable = true;
        enableUdevRules = true;
      };
      joycond.enable = true;
    };
  };
}
