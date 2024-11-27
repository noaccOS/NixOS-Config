{
  pkgs,
  lib,
  config,
  monitors,
  ...
}:
let
  cfg = config.homeModules.windowManagers.niri;

  inherit (builtins) readFile;

  inherit (lib)
    getExe
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    pipe
    concatStringsSep
    types
    ;

  monitorSection = pipe monitors [
    (mapAttrsToList (
      key: value: ''
        output "${key}" {
          mode "${toString value.mode.x}x${toString value.mode.y}"
          scale "${toString value.scale}";
          transform "${value.rotation}";
          position x=${toString value.position.x} y=${toString value.position.y}
        }
      ''
    ))
    (concatStringsSep "\n")
  ];
in
{
  options.homeModules.windowManagers.niri = {
    enable = mkEnableOption "niri";
    greeter-command = mkOption {
      type = types.str;
      readOnly = true;
      default = getExe config.programs.niri.package;
    };
    package = mkOption {
      type = types.package;
      readOnly = true;
      default = config.programs.niri.package;
    };
  };
  config = mkIf cfg.enable {
    homeModules.windowManagers.gnome-shell.enable = true;
    homeModules.programs.launchers.anyrun.enable = true;
    homeModules.windowManagers.bars.waybar.enable = true;

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];

    programs.niri = {
      enable = true;
      config = monitorSection + "\n" + (readFile ../../../config/niri/config.kdl);
    };
  };
}
