{ config, pkgs, ...}:
let kp = config.boot.kernelPackages;
in
{
  boot.extraModulePackages = [ kp.xpadneo ];
  
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging
    winetricks
    
    gamemode
    mangohud
    
    # polymc
    # prismlauncher
    lutris
    heroic
    yuzu-mainline
    ryujinx
  ];
  
  programs.steam.enable = true;

  services = {
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };
    joycond.enable = true;
  };
}
