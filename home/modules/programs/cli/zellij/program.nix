{
  pkgs,
  lib,
  config,
  inputs,
  system,
  ...
}:
let
  simpleLayout = ''
    layout {
      pane
    }
  '';

  layoutFile = pkgs.writeTextDir "default.kdl" simpleLayout;
  layoutDir = layoutFile.outPath;

  keybindings = builtins.readFile ./keybindings.kdl;

  settings = lib.hm.generators.toKDL { } {
    simplified_ui = true;
    pane_frames = false;
    layout_dir = layoutDir;
    copy_on_select = false;
  };

  zellijconfig = keybindings + "\n" + settings;

  cfg = config.homeModules.programs.cli.zellij;
in
with lib;
{
  options.homeModules.programs.cli.zellij = {
    enable = mkEnableOption "zellij";
  };
  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };

    programs.alacritty.settings = {
      shell = {
        program = "${config.programs.zellij.package}/bin/zellij";
        args = [
          "-l"
          "welcome"
        ];
      };
    };

    xdg.configFile."zellij/config.kdl".text = zellijconfig;
  };
}
