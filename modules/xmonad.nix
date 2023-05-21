{ pkgs, lib, config, ... }:
let
  cfg = config.noaccOSModules.xmonad;
in
{
  options.noaccOSModules.xmonad = {
    enable = lib.mkEnableOption "XMonad window manager packages and options";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      feh
      rofi
      taffybar
      xmobar
      flameshot
      blueman
    ];

    services = {
      dbus = {
        enable = true;
        packages = [ pkgs.dconf ];
      };

      xserver = {
        enable = true;
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
    };
  };
}
