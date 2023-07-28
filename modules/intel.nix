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
          rev = "357ebf9a227bd5b4bd87b610dd6545d8a81ba265";
          sha256 = "sha256-2bplmWu9qcSRdbaFzL7k5XOaAhq4in2UL4JaZ8kksDA=";
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
