{
  inputs,
  lib,
  config,
  user,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    optional
    types
    ;
  cfg = config.noaccOSModules.windowManager;
  hmCfg = config.home-manager.users.${user};
in
{
  options.noaccOSModules.windowManager = {
    enable = mkEnableOption "window managers";

    windowManager = mkOption {
      description = "The window manager to enable";
      type = types.enum [
        "niri"
      ];
      default = "niri";
    };
  };

  config = mkIf cfg.enable {
    noaccOSModules.gnome.enable = true;
    noaccOSModules.gnome.barebones = mkDefault true;

    services.displayManager.sessionPackages = [
      hmCfg.homeModules.windowManagers.${cfg.windowManager}.package
    ];

    # programs.niri = {
    #   enable = cfg.windowManager == "niri";
    # };

    home-manager.users.${user}.homeModules.windowManagers.${cfg.windowManager}.enable = true;
  };
}
