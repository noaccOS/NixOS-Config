{
  config,
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
    style = ''
      * {
        font-family: Inter Nerd Font;
      }
    '';
    settings = [
      {
        layer = "top";
        position = "top";
        spacing = "4";
        modules-left = [
          "niri/workspaces"
          "niri/window"

        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "battery"
          "network"
          "pulseaudio"
        ];
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            urgent = " ";
            active = " ";
            default = " ";
          };
        };
        clock = {
          format = "{:%a, %b %d %R}";
          format-alt = "{:%Y}";
        };
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}";
          format-charging = "{capacity}%  ";
          format-plugged = "{capacity}%  ";
          format-alt = "{capacity}% {time}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };
        network = {
          fromat = "{icon}";
          format-icons = {
            wifi = " ";
            ethernet = " ";
            linked = "󰅛 ";
            disconnected = "󰲛 ";
          };
          tooltip-format = "{ifname} via {gwaddr}  ";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          format = "{icon}";
          format-bluetooth = "{volume}% {icon}󰂯 {format_source}";
          format-bluetooth-muted = "  {icon}󰂯 {format_source}";
          format-muted = "  {format_source}";
          format-source = "{volume}%  ";
          format-source-muted = " ";
          format-icons = {
            headphone = " ";
            hands-free = " ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = [
              " "
              " "
              " "
            ];
          };
          on-click = "pavucontrol";
        };
      }
    ];
  };
}
