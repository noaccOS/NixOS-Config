{ pkgs, lib, config, ... }:
let
  cfg = config.noaccOSModules.intel;
  gnomeOverlay = self: super: {
    gnome = super.gnome.overrideScope' (gself: gsuper: {
    mutter = gsuper.mutter.overrideAttrs (oldAttrs: {
      src = super.fetchFromGitLab {
        domain = "gitlab.gnome.org";
        owner = "Community/Ubuntu";
        repo = "mutter";
        rev = "1e2436d15c717e9bc18dc6c11782ae806c3437cb";
        sha256 = "sha256-jzdZqBaj9fwTr3pHXpC6x8KdBms0w25rrJ4EEg7HaF0=";
      };
    });
  });
  };
in
{
  options.noaccOSModules.intel = {
    enable = lib.mkEnableOption "Intel gpu specific options";
  };

  config = lib.mkIf cfg.enable {
    hardware.opengl.extraPackages = with pkgs; [
      vaapiIntel
      intel-media-driver
    ];

    nixpkgs.overlays = [ gnomeOverlay ];
  };
}
