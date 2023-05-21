{ config, pkgs, ... }:
{
  programs = {
    foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=11";
          pad = "20x20";
        };
        colors = {
          foreground = "cdd6f4"; # Text
          background = "1e1e2e"; # Base
          regular0 = "45475a"; # Surface 1
          regular1 = "f38ba8"; # red
          regular2 = "a6e3a1"; # green
          regular3 = "f9e2af"; # yellow
          regular4 = "89b4fa"; # blue
          regular5 = "f5c2e7"; # pink
          regular6 = "94e2d5"; # teal
          regular7 = "bac2de"; # Subtext 1
          bright0 = "585b70"; # Surface 2
          bright1 = "f38ba8"; # red
          bright2 = "a6e3a1"; # green
          bright3 = "f9e2af"; # yellow
          bright4 = "89b4fa"; # blue
          bright5 = "f5c2e7"; # pink
          bright6 = "94e2d5"; # teal
          bright7 = "a6adc8"; # Subtext 0
        };
        csd = {
          preferred = "client";
        };
      };
    };
    noaccos-wezterm = {
      # enable = true;
      font = {
        family = [
          "JetBrainsMono Nerd Font"
          "JetBrains Mono"
          "Segoe UI Symbol"
          "Cambria"
          "JoyPixels"
        ];
        size = 12;
      };
      closePromptEnable = false;
      tabBarEnable = false;
      waylandEnable = false;
      padding = {
        left = 20;
        right = 20;
        top = 20;
        bottom = 20;
      };
    };

    mpv = {
      enable = true;
      config = {
        # Language
        alang = "jpn,ja,jp,eng,en"; # audio lang
        slang = "eng,en"; # sub   lang

        # 2x
        af = "scaletempo2";
        speed = 2;

        # Subtitles
        sub-font = "Noto Sans";
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
      };
    };
  };
}
