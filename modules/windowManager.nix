{
  lib,
  config,
  user,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.noaccOSModules.windowManager;
  hmCfg = config.home-manager.users.${user};
in
{
  options.noaccOSModules.windowManager = {
    enable = mkEnableOption "window managers";

    primary = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to also set up the greeter";
    };

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

    # maybe look into greetd eventually, for now gdm works
    services.xserver.displayManager.gdm.enable = cfg.primary;

    home-manager.users.${user} = {
      homeModules.windowManagers.${cfg.windowManager}.enable = true;

      # TODO: use gsconnect eventually
      services.kdeconnect.enable = true;
    };
  };
}
