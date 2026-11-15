# FFmpeg with the V4L2 Request API hwaccels (stateless decoders: rkvdec, hantro, cedrus, ...),
# not yet upstream: https://code.ffmpeg.org/FFmpeg/FFmpeg/pulls/20847.
# Uses the patches LibreELEC carries for FFmpeg 9.0.x on RK3588; bump the commit together with FFmpeg.
{
  lib,
  ffmpeg,
  fetchurl,
  udev,
}:
let
  libreelecRev = "01a57f984b2b798795d1698d3a4aa2c9de43db7e";
  # fetchurl, not fetchpatch: its normalization regroups hunks by file, which breaks these
  # multi-commit series (later commits edit files created by earlier ones)
  libreelecPatch =
    path: hash:
    fetchurl {
      url = "https://raw.githubusercontent.com/LibreELEC/LibreELEC.tv/${libreelecRev}/packages/multimedia/ffmpeg/patches/${path}";
      inherit hash;
    };
in
ffmpeg.overrideAttrs (oldAttrs: {
  pname = "ffmpeg-v4l2request";

  patches = (oldAttrs.patches or [ ]) ++ [
    # Kwiboo's hwaccels for MPEG-2, H.264, HEVC, VP8, VP9 and AV1
    (libreelecPatch "v4l2-request/0001-v4l2-request.patch" "sha256-r9BMICwnCBw1XY00tYpSxBQd4mQzAH4n7W4NIJPRDTw=")
    # HEVC short-term RPS control, required by the RK3588 rkvdec (VDPU381) driver
    (libreelecPatch "detlev/0001-hevc-Add-support-for-sps_st_rps-control.patch" "sha256-UsHlickIuULy247ZZZJM0kAU2GMuFl95AbyioKkxgMA=")
  ];

  buildInputs = oldAttrs.buildInputs ++ [ udev ];

  configureFlags = oldAttrs.configureFlags ++ [
    "--enable-libudev"
    "--enable-v4l2-request"
  ];

  # configure silently drops hwaccels whose dependencies (eg. kernel headers) are missing
  # (nixpkgs' postConfigure has no trailing newline)
  postConfigure = (oldAttrs.postConfigure or "") + ''

    for hwaccel in H264 HEVC; do
      grep -q "^#define CONFIG_''${hwaccel}_V4L2REQUEST_HWACCEL 1" config.h \
        || { echo "''${hwaccel} v4l2request hwaccel was not enabled"; exit 1; }
    done
  '';

  meta = oldAttrs.meta // {
    description = "${oldAttrs.meta.description} (with V4L2 Request API hwaccels)";
    platforms = lib.platforms.linux;
  };
})
