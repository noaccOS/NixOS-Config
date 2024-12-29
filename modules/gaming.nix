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

      mangohud

      # polymc
      # prismlauncher
      lutris
      heroic
    ];

    hardware.xpadneo.enable = true;
    programs.gamemode.enable = true;
    programs.steam.enable = true;
    programs.steam.package = pkgs.steam.override {
      extraEnv = {
        XMODIFIERS = "@im=none";
      };
    };

    services = {
      input-remapper = {
        enable = true;
        enableUdevRules = true;
      };
      joycond.enable = true;
    };
  };
}
