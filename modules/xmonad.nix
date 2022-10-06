{ pkgs, config, lib, ... }:
{
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
}
