{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.noaccOSModules.plasma;
in
{
  options.noaccOSModules.plasma = {
    enable = lib.mkEnableOption "KDE Plasma desktop environment";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.kde-gtk-config
      pkgs.latte-dock
      pkgs.plasma-browser-integration
      pkgs.libsForQt5.krunner
    ];

    services.xserver = {
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
      };

      desktopManager.plasma5.enable = true;
    };
  };
}
