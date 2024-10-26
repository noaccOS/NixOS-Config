{
  config,
  lib,
  ...
}:
let
  cfg = config.homeModules.programs.terminals.rio;
in
with lib;
{
  options.homeModules.programs.terminals.rio = {
    enable = mkEnableOption "rio";
  };

  config.programs.rio = {
    enable = cfg.enable;
    settings = {
      editor.program = config.home.sessionVariables.EDITOR;
      editor.args = [ ];
      keyboard.use-kitty-keyboard-protocol = true;
      cursor.shape = "beam";
      cursor.blinking = false;
      renderer = {
        performance = "High";
        backend = "Vulkan";
        level = 1;
      };
      fonts = {
        family = "JetBrainsMono Nerd Font";
        size = 18;
        emoji.family = "JoyPixels";
        bold.weight = 700;
        extras = [
          { family = "Noto Sans Mono CJK JP"; }
          { family = "Noto Sans Mono CJK HK"; }
          { family = "Noto Sans Mono CJK KR"; }
          { family = "Noto Sans Mono CJK SC"; }
          { family = "Noto Sans Mono CJK TC"; }
        ];
      };
    };
  };
}
