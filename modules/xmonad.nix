{ pkgs, config, lib, ... }:
{
  # Useful only until xmonad gets updated to 0.17
  nixpkgs.overlays = [
    (self: super: {
      haskellPackages = super.haskellPackages.override {
        overrides = hself: hsuper: {
          xmonad = hsuper.xmonad_0_17_0;
          xmonad-contrib = hsuper.xmonad-contrib_0_17_0;
          xmonad-extras = hsuper.xmonad-extras_0_17_0;
        };};
    })
  ];

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


      displayManager.defaultSession = "none+xmonad";
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };
}
