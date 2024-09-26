{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.windowManagers.bars.waybar;

  inherit (lib) mkEnableOption mkOption types;
in
{
  options.homeModules.windowManagers.bars.waybar = {
    enable = mkEnableOption "waybar";
    target = mkOption {
      type = types.nullOr types.str;
      description = "systemd target for waybar. if != null, enables systemd integration";
      default = null;
    };
  };

  config.programs.waybar = {
    enable = cfg.enable;
  };
}
