{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.programs.video.mpv;
in
{
  options.homeModules.programs.video.mpv = {
    enable = lib.mkEnableOption "mpv";
  };
  config.programs.mpv = {
    enable = cfg.enable;
    config = {
      # Language
      alang = "jpn,ja,jp,eng,en"; # audio lang
      slang = "eng,en"; # sub   lang

      # 2x
      af = "scaletempo2";
      speed = 2;

      # Subtitles
      sub-font = "Atkinson Hyperlegible Next";
      sub-font-size = 36;
      sub-color = "#FFFFFF";
      sub-border-color = "#131313";
      sub-border-size = 3.2;

      # Screenshots
      screenshot-format = "png";
      screenshot-directory = "~/Pictures/Screenshots/mpv";
    };

    bindings = {
      WHEEL_UP = "add volume 5";
      WHEEL_DOWN = "add volume -5";
      "{" = "add speed -.25";
      "}" = "add speed  .25";
      "[" = "add speed   -1";
      "]" = "add speed    1";

      # override scripts bindings
      g = "ignore";
      G = "add sub-scale +0.1";
      h = "ignore";
      H = "ignore";
    };

    scripts = with pkgs.mpvScripts; [
      mpvacious
      smart-copy-paste-2
      smartskip
      sponsorblock
      thumbfast
      uosc
    ];
  };
}
