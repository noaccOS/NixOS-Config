{
  pkgs,
  lib,
  config,
  monitors,
  ...
}:
let
  cfg = config.homeModules.windowManagers.niri;

  inherit (builtins) mapAttrs;

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
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

  # TODO: this should be a property of the bar using gsconnect
  kmonad = {
    argv = [
      "${getExe pkgs.kmonad}"
      "${cfg.kmonad.config}"
    ];
  };

  niri-cmd = types.either types.str (types.listOf types.str);
  mkNiriCmdOption =
    default:
    mkOption {
      type = niri-cmd;
      inherit default;
    };
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
    terminal = mkNiriCmdOption "ghostty";
    application-launcher = mkNiriCmdOption "anyrun";
    lockscreen = mkNiriCmdOption "hyprlock";
    raise-volume = mkNiriCmdOption [
      "wpctl"
      "set-volume"
      "@DEFAULT_AUDIO_SINK@"
      "0.1+"
    ];
    lower-volume = mkNiriCmdOption [
      "wpctl"
      "set-volume"
      "@DEFAULT_AUDIO_SINK@"
      "0.1-"
    ];
    mute = mkNiriCmdOption [
      "wpctl"
      "set-mute"
      "@DEFAULT_AUDIO_SINK@"
      "toggle"
    ];
    mute-mic = mkNiriCmdOption [
      "wpctl"
      "set-mute"
      "@DEFAULT_AUDIO_SOURCE@"
      "toggle"
    ];
    media-play-pause = mkNiriCmdOption [
      "playerctl"
      "play-pause"
    ];
    media-previous = mkNiriCmdOption [
      "playerctl"
      "previous"
    ];
    media-next = mkNiriCmdOption [
      "playerctl"
      "next"
    ];
    brightness-up = mkNiriCmdOption [
      "brightnessctl"
      "set"
      "5%+"
    ];
    brightness-down = mkNiriCmdOption [
      "brightnessctl"
      "set"
      "5%-"
    ];
  };
  config = mkIf cfg.enable {
    homeModules.windowManagers.dms.enable = true;
    homeModules.windowManagers.gnome-shell.enable = true;

    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];

    home.packages = [
      pkgs.dex
      pkgs.xwayland-satellite
    ];

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        cursor = {
          theme = "Breeze_Catppuccin";
          size = 32;
        };
        input.keyboard.xkb.layout = "us";
        layout = {
          gaps = 48;
          always-center-single-column = true;
          empty-workspace-above-first = true;
          center-focused-column = "never";
          default-column-width.proportion = 0.5;
          focus-ring = {
            width = 4;
            inactive.color = "#b4befe";
            active.gradient = {
              from = "#b4befe";
              to = "#f9e2af";
              angle = 135;
              in' = "oklch shorter hue";
            };
          };
          preset-column-widths = [
            { proportion = 0.25; }
            { proportion = 1. / 3.; }
            { proportion = 0.5; }
            { proportion = 2. / 3.; }
            { proportion = 0.75; }
          ];
        };
        window-rules = [
          {
            geometry-corner-radius = {
              bottom-left = 12.;
              bottom-right = 12.;
              top-left = 12.;
              top-right = 12.;
            };
            clip-to-geometry = true;
          }
        ];
        prefer-no-csd = true;
        screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        outputs = mapAttrs (_: value: {
          inherit (value) scale position;

          transform = { "normal" = { }; }.${value.rotation};

          mode = {
            width = value.mode.x;
            height = value.mode.y;
            refresh = if value.mode ? hz then value.mode.hz * 1. else null;
          };
        }) monitors;

        spawn-at-startup =
          let
            dex = {
              argv = [
                "dex"
                "-a"
              ];
            };
          in
          if cfg.kmonad.enable then
            [
              dex
              kmonad
            ]
          else
            [ dex ];

        binds = {
          "Mod+E".action.spawn = cfg.terminal;
          "Mod+U".action.spawn = cfg.application-launcher;
          "Mod+J".action.spawn = cfg.lockscreen;
          "Mod+Shift+J".action.quit = { };

          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn = cfg.raise-volume;
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn = cfg.lower-volume;
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn = cfg.mute;
          };
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action.spawn = cfg.mute-mic;
          };
          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn = cfg.media-play-pause;
          };
          "XF86AudioPrev" = {
            allow-when-locked = true;
            action.spawn = cfg.media-previous;
          };
          "XF86AudioNext" = {
            allow-when-locked = true;
            action.spawn = cfg.media-next;
          };
          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action.spawn = cfg.brightness-up;
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action.spawn = cfg.brightness-down;
          };

          "Mod+Shift+Slash".action.show-hotkey-overlay = { };
          "Mod+Q".action.close-window = { };

          "Mod+Left".action.focus-column-left = { };
          "Mod+Down".action.focus-window-down = { };
          "Mod+Up".action.focus-window-up = { };
          "Mod+Right".action.focus-column-right = { };
          "Mod+H".action.focus-column-left = { };
          "Mod+T".action.focus-window-down = { };
          "Mod+N".action.focus-window-up = { };
          "Mod+S".action.focus-column-right = { };

          "Mod+Shift+Left".action.move-column-left = { };
          "Mod+Shift+Down".action.move-window-down = { };
          "Mod+Shift+Up".action.move-window-up = { };
          "Mod+Shift+Right".action.move-column-right = { };
          "Mod+Shift+H".action.move-column-left = { };
          "Mod+Shift+T".action.move-window-down = { };
          "Mod+Shift+N".action.move-window-up = { };
          "Mod+Shift+S".action.move-column-right = { };

          "Mod+Home".action.focus-column-first = { };
          "Mod+End".action.focus-column-last = { };
          "Mod+Shift+Home".action.move-column-to-first = { };
          "Mod+Shift+End".action.move-column-to-last = { };

          "Mod+G".action.focus-monitor-left = { };
          "Mod+L".action.focus-monitor-right = { };

          "Mod+Shift+G".action.move-column-to-monitor-left = { };
          "Mod+Shift+L".action.move-column-to-monitor-right = { };
          "Mod+WheelScrollDown" = {
            cooldown-ms = 150;
            action.focus-workspace-down = { };
          };
          "Mod+WheelScrollUp" = {
            cooldown-ms = 150;
            action.focus-workspace-up = { };
          };
          "Mod+Ctrl+WheelScrollDown" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-down = { };
          };
          "Mod+Ctrl+WheelScrollUp" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-up = { };
          };
          "Mod+WheelScrollRight".action.focus-column-right = { };
          "Mod+WheelScrollLeft".action.focus-column-left = { };
          "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
          "Mod+Shift+WheelScrollUp".action.focus-column-left = { };

          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Ctrl+1".action.move-column-to-workspace = 1;
          "Mod+Ctrl+2".action.move-column-to-workspace = 2;
          "Mod+Ctrl+3".action.move-column-to-workspace = 3;
          "Mod+Ctrl+4".action.move-column-to-workspace = 4;
          "Mod+Ctrl+5".action.move-column-to-workspace = 5;
          "Mod+Ctrl+6".action.move-column-to-workspace = 6;
          "Mod+Ctrl+7".action.move-column-to-workspace = 7;
          "Mod+Ctrl+8".action.move-column-to-workspace = 8;
          "Mod+Ctrl+9".action.move-column-to-workspace = 9;

          "Mod+C".action.focus-workspace-down = { };
          "Mod+R".action.focus-workspace-up = { };
          "Mod+Shift+C".action.move-column-to-workspace-down = { };
          "Mod+Shift+R".action.move-column-to-workspace-up = { };

          "Mod+Comma".action.consume-or-expel-window-left = { };
          "Mod+Period".action.consume-or-expel-window-right = { };

          "Mod+A".action.maximize-column = { };
          "Mod+Shift+A".action.fullscreen-window = { };

          "Mod+B".action.set-column-width = "50%";
          "Mod+M".action.set-column-width = "25%";
          "Mod+W".action.set-column-width = "33.3333%";
          "Mod+V".action.set-column-width = "66.6667%";
          "Mod+Z".action.set-column-width = "75%";

          "Mod+Shift+B".action.switch-preset-column-width = { };
          "Mod+Shift+M".action.set-column-width = "-10%";
          "Mod+Shift+V".action.set-window-height = "-10%";
          "Mod+Shift+W".action.set-window-height = "+10%";
          "Mod+Shift+Z".action.set-column-width = "+10%";

          "Mod+Space".action.switch-layout = "next";
          "Mod+D".action.toggle-window-floating = { };
          "Mod+Shift+D".action.switch-focus-between-floating-and-tiling = { };

          "Mod+O".action.screenshot = { };
          "Ctrl+Print".action.screenshot-screen = { };
          "Alt+Print".action.screenshot-window = { };
        };

      };
    };
  };
}
