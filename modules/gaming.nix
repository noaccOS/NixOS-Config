{pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging
    (winetricks.override { wine = wineWowPackages.staging; })
    
    gamemode
    mangohud
    
    multimc
    lutris
    yuzu-ea
  ];
  
  nixpkgs.config.steam  = pkgs.steam.override { nativeOnly = true; };
  programs.steam.enable = true;
}
