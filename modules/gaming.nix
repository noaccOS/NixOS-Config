{ lib, config, pkgs, currentSystem, ... }:
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

    nixpkgs.overlays =
      let
        pkgs_ibus_27 = import
          (pkgs.fetchFromGitHub {
            owner = "NixOS";
            repo = "nixpkgs";
            rev = "8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8";
            sha256 = "sha256-0gI2FHID8XYD3504kLFRLH3C2GmMCzVMC50APV/kZp8=";
          })
          { system = currentSystem; };
      in
      [
        (final: prev: {
          ibus = pkgs_ibus_27.ibus;
        })
      ];

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
