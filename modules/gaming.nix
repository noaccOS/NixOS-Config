{pkgs, ...}:
{
  boot.extraModulePackages = with pkgs.linuxKernel.packages.linux_xanmod;
    [ hid-nintendo xpadneo ];
  
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging
    (winetricks.override { wine = wineWowPackages.staging; })
    
    gamemode
    mangohud
    
    multimc
    lutris-unwrapped
    yuzu-ea
  ];
  
  nixpkgs.config.steam  = pkgs.steam.override { nativeOnly = true; };
  programs.steam.enable = true;
}
