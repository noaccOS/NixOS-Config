{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      wl-clipboard
      alacritty
      dmenu
    ];
  };
}
