{ pkgs, lib, config, inputs, ... }:
let
  cfg = config.noaccOSModules.intel;

  mutterTripleBufferOverlay = (self: super: {
    gnome = super.gnome.overrideScope' (gself: gsuper: {
      mutter = gsuper.mutter.overrideAttrs ({
        src = inputs.mutter-triple-buffer;
      });
    });
  });
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

    nixpkgs.overlays = [ mutterTripleBufferOverlay ];
  };
}
