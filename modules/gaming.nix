{ config, pkgs, ...}:
let kp = config.boot.kernelPackages;
in
{
  boot.extraModulePackages = with kp;
    [ xpadneo ];
  # boot.kernelModules = ["hid_nintendo"];
  
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging
    winetricks
    
    gamemode
    mangohud
    
    polymc
    lutris-unwrapped
    (yuzu-mainline.override {
      version = "905";
      src = fetchFromGitHub {
        owner = "yuzu-emu";
        repo = "yuzu-mainline";
        rev = "mainline-0-905";
        sha256 = "2OYkeR1SbffVKUEHUlaYGFdumhhfK0VZtuh8Lbenb2M=";
        fetchSubmodules = true;
      };
    })

  #  kp.hid-nintendo
  ];
  
  # nixpkgs.config.steam  = pkgs.steam.override { nativeOnly = true; };
  # nixpkgs.config.packageOverrides = pkgs: {
  #   steam = pkgs.steam.override {
  #     nativeOnly = true; 
  #   };
  # };
  programs.steam.enable = true;

  services.joycond.enable = true;
}
