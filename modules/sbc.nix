{
  config,
  inputs,
  lib,
  pkgs,
  user,
  ...
}:
let
  cfg = config.noaccOSModules.sbc;

  # Kodi only uses DRM PRIME decoders (and so v4l2request) with its GLES renderer. Without X11,
  # VDPAU can't force GLX on, which doesn't work with GLES.
  kodi = inputs.kodi-scaletempo2.packages.${pkgs.stdenv.hostPlatform.system}.kodi-wayland.override {
    ffmpeg = pkgs.callPackage ../packages/ffmpeg-v4l2request/package.nix { };
    renderSystem = "gles";
    x11Support = false;
    vdpauSupport = false;
  };
in
{
  options.noaccOSModules.sbc = {
    enable = lib.mkEnableOption "Utilities for SBCs";
  };

  config = lib.mkIf cfg.enable {
    boot.growPartition = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    environment.systemPackages = with pkgs; [
      e2fsprogs
    ];

    environment.pathsToLink = [
      "/share/applications"
      "/share/xdg-desktop-portal"
    ];

    # Stateless hardware decoding (rkvdec, hantro) through the V4L2 Request API
    home-manager.users.${user} = {
      homeModules.programs.video.mpv.unwrappedPackage =
        pkgs.callPackage ../packages/mpv-v4l2request/package.nix
          { };
      programs.mpv.config.hwdec = lib.mkForce "v4l2request";

      homeModules.homeTheater.package = kodi;
      # "Allow using DRM PRIME decoder", off by default
      homeModules.homeTheater.guiSettings."videoplayer.useprimedecoder" = "true";
    };

    disko = {
      imageBuilder =
        let
          pkgs-x86_64 = inputs.nixpkgs.legacyPackages.x86_64-linux;
        in
        {
          enableBinfmt = true;
          pkgs = pkgs-x86_64;
          kernelPackages = pkgs-x86_64.linuxPackages_latest;
        };
    };
  };
}
