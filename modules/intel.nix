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
          rev = "1bf8ae3e26a7508be4e2901c1afc025aea7d8465";
          sha256 = "sha256-GoJRuPXNXyEGuhgEPFXdCXZMKS/H2GnrOTzyIuj/zho=";
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
      intel-compute-runtime
    ];

    nixpkgs.overlays = [ gnomeOverlay ];
  };
}
