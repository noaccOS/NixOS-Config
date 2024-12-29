{
  pkgs,
  lib,
  config,
  inputs,
  monitors,
  ...
}:
let
  cfg = config.homeModules.windowManagers.niri;

  inherit (builtins) readFile;

  inherit (lib)
    concatLines
    getExe
    mapAttrsToList
    mkEnableOption
    mkIf
    mkOption
    optionalString
    pipe
    types
    ;

  kmonadSubmodule = {
    options = {
      enable = mkEnableOption "Run kmonad when niri starts";

      config = mkOption {
        type = types.path;
        description = "KMonad configuration";
      };
    };
  };

  outputMode =
    monitor:
    let
      baseMode = "${toString monitor.mode.x}x${toString monitor.mode.y}";
    in
    if (monitor.mode ? hz) then "${baseMode}@${toString monitor.mode.hz}" else baseMode;

  monitorSection = pipe monitors [
    (mapAttrsToList (
      key: value: ''
        output "${key}" {
          mode "${outputMode value}"
          scale ${toString value.scale};
          transform "${value.rotation}";
          position x=${toString value.position.x} y=${toString value.position.y}
        }
      ''
    ))
    concatLines
  ];

  xwayland = "spawn-at-startup \"${getExe pkgs.xwayland-satellite}\"\n";
  # TODO: this should be a property of the bar using gsconnect
  kmonad = optionalString cfg.kmonad.enable ''
    spawn-at-startup "${getExe pkgs.kmonad}" "${cfg.kmonad.config}"
  '';
  swaync = "spawn-at-startup \"${getExe pkgs.swaynotificationcenter}\"\n";
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
    kmonad = mkOption {
      type = types.submodule kmonadSubmodule;
      description = "TEMPORARY: move this option to the bar";
      default = { };
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
      package = inputs.niri.packages.${pkgs.system}.niri-unstable;
      config = monitorSection + kmonad + xwayland + swaync + (readFile ../../../config/niri/config.kdl);
    };
  };
}
