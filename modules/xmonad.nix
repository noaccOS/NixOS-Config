{ pkgs, config, lib, ... }:
{
  # Useful only until xmonad gets updated to 0.17
  # nixpkgs.config.packageOverrides = super: {
  #   haskellPackages.xmonad = super.haskellPackages.xmonad_0_17_0;
  # };
  
  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
    };

    xserver = {
      enable = true;


      displayManager.defaultSession = "none+xmonad";
      windowManager.xmonad = {
        enable = true;
        extraPackages = haskellPackages: [ haskellPackages.xmonad-contrib ];
      };
    };
  };
}
