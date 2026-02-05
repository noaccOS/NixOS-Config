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

  # TODO: this should be a property of the bar using gsconnect
  kmonad = optionalString cfg.kmonad.enable ''
    spawn-at-startup "${getExe pkgs.kmonad}" "${cfg.kmonad.config}"
  '';
  swaync = "spawn-at-startup \"${getExe pkgs.swaynotificationcenter}\"\n";
  wallpaper = ''
    spawn-at-startup "swaybg" "-i" "${../../../assets/wallpaper.jpg}" "-m" "fill" 
  '';
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

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 5;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 5;
          }
        ];
      };
    };

    home.packages = [
      pkgs.brightnessctl
      pkgs.dex
      pkgs.playerctl
      pkgs.swaybg
      pkgs.xwayland-satellite
    ];

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      config = monitorSection + kmonad + swaync + wallpaper + (readFile ../../../config/niri/config.kdl);
    };
  };
}
