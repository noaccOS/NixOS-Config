{ pkgs, lib, config, inputs, system, ... }:
let
  simpleLayout = ''
    layout {
      pane size=1 borderless=true {
        plugin location="zellij:status-bar"
      }
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
    theme = "catppuccin-mocha";
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
      enableFishIntegration = true;
    };

    xdg.configFile."zellij/config.kdl".text = zellijconfig;
  };
}
