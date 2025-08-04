{ config, lib, ... }:
let
  cfg = config.homeModules.programs.terminals.kitty;

  inherit (lib)
    attrValues
    concatStringsSep
    flatten
    getExe
    mkEnableOption
    mkIf
    pipe
    ;

  japanese_code_points = {
    hiragana = {
      from = "3041";
      to = "3096";
    };
    katakana = {
      from = "30A0";
      to = "30FF";
    };
    kanji = [
      {
        from = "3400";
        to = "4DB5";
      }
      {
        from = "4E00";
        to = "9FCB";
      }
      {
        from = "F900";
        to = "FA6A";
      }
    ];
    radicals = {
      from = "2E80";
      to = "2FD5";
    };
    half_width = {
      from = "FF5F";
      to = "FF9F";
    };
    symbols = {
      from = "3000";
      to = "303F";
    };
    misc = [
      {
        from = "31F0";
        to = "31FF";
      }
      {
        from = "3220";
        to = "3243";
      }
      {
        from = "3280";
        to = "337F";
      }
    ];
    western = {
      from = "FF01";
      to = "FF5E";
    };
  };

  unicodeRangeToKittyRange = range: "U+${range.from}-U+${range.to}";
in
{
  options.homeModules.programs.terminals.kitty = {
    enable = mkEnableOption "kitty";
  };

  config.programs.kitty = mkIf cfg.enable {
    enable = true;
    font = {
      name = "Nosevka NF";
      size = 13;
    };
    keybindings = {
      "alt+d" = "launch --location=split --cwd=current";
      "alt+r" = "launch --location=vsplit --cwd=current";
      "alt+h" = "neighboring_window left";
      "alt+s" = "neighboring_window right";
      "alt+n" = "neighboring_window up";
      "alt+t" = "neighboring_window down";
      "alt+enter" = "start_resizing_window";
    };
    settings =
      let
        japanese_map = pipe japanese_code_points [
          attrValues
          flatten
          (map unicodeRangeToKittyRange)
          (concatStringsSep ",")
        ];
      in
      {
        # shell = mkIf config.homeModules.programs.shells.nu.enable (getExe config.programs.nushell.package);
        input_delay = "0";
        repaint_delay = "2";
        cursor_shape = "beam";
        cursor_blink_interval = "0";
        mouse_hide_wait = "0";
        confirm_os_window_close = "0";
        disable_ligatures_in = "active cursor";
        symbol_map = "${japanese_map} Noto Sans Mono CJK JP";
      };
  };
}
