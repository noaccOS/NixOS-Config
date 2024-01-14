{ config, lib, ... }:
let cfg = config.homeModules.programs.terminals.rio;
in with lib; {
  options.homeModules.programs.terminals.rio = {
    enable = mkEnableOption "rio";
  };

  config.programs.rio = {
    enable = cfg.enable;
    settings = {
      editor = config.home.sessionVariables.EDITOR;
      use-kitty-keyboard-protocol = true;
      fonts = {
        family = "JetBrainsMono Nerd Font";
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
