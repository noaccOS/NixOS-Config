# mpv with --hwdec=v4l2request, for FFmpeg's V4L2 Request API hwaccels (see ../ffmpeg-v4l2request).
# Not yet upstream: https://github.com/mpv-player/mpv/pull/14690, waiting on the FFmpeg side.
{
  mpv-unwrapped,
  fetchpatch,
  callPackage,
}:
(mpv-unwrapped.override {
  ffmpeg = callPackage ../ffmpeg-v4l2request/package.nix { };
}).overrideAttrs
  (oldAttrs: {
    pname = "mpv-v4l2request";

    patches = (oldAttrs.patches or [ ]) ++ [
      # meson: add detection logic for v4l2request support
      (fetchpatch {
        url = "https://github.com/philipl/mpv/commit/1800573999b29a145de3eb303a0b51d840a6b3de.patch";
        hash = "sha256-3Ov78qB+37/UWGaWrlHmZt4Bxj9YDxb1DkW4cEw2+EU=";
      })
      # vo: hwdec: drmprime: add separate hwdecs for v4l2request
      (fetchpatch {
        url = "https://github.com/philipl/mpv/commit/beb3771179b45096702c0b15704bf5b0ca5f9d61.patch";
        hash = "sha256-z/R+G1FRyRjN99uB7DRfda1rQWR6lVMO8/cVo0DVmqU=";
      })
    ];

    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dv4l2request=enabled" ];
  })
