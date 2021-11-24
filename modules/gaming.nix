{pkgs, ...}:
{
  boot.extraModulePackages = with pkgs.linuxKernel.packages.linux_xanmod;
    [ xpadneo ];
  
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging
    winetricks
    
    gamemode
    mangohud
    
    multimc
    lutris-unwrapped
    yuzu-ea
  ];
  
  nixpkgs.config.steam  = pkgs.steam.override { nativeOnly = true; };
  programs.steam.enable = true;

  services.joycond.enable = true;
}
