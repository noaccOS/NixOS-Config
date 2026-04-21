{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.noaccOSModules.sbc;
in
{
  options.noaccOSModules.sbc = {
    enable = lib.mkEnableOption "Utilities for SBCs";
  };

  config = lib.mkIf cfg.enable {
    boot.growPartition = true;

    environment.systemPackages = with pkgs; [
      e2fsprogs
      iwd
    ];

    disko = {
      imageBuilder =
        let
          pkgs-x86_64 = inputs.nixpkgs.legacyPackages.x86_64-linux;
        in
        {
          enableBinfmt = true;
          pkgs = pkgs-x86_64;
          kernelPackages = pkgs-x86_64.linuxPackages_latest;
        };
    };
  };
}
