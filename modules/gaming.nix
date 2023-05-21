{ lib, config, pkgs, ... }:
let
  kp = config.boot.kernelPackages;
  cfg = config.noaccOSModules.gaming;
in
{
  options.noaccOSModules.gaming = {
    enable = lib.mkEnableOption "Various launchers and gaming drivers";
  };

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ kp.xpadneo ];


    environment.systemPackages = with pkgs; [
      wineWowPackages.staging
      winetricks

      gamemode
      mangohud

      # polymc
      # prismlauncher
      lutris
      heroic
      yuzu-mainline
      ryujinx
    ];

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
