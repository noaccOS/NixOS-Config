{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) readFile;
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.hm.generators) toKDL;

  simpleLayout = ''
    layout {
      pane
    }
  '';

  layoutFile = pkgs.writeTextDir "default.kdl" simpleLayout;
  layoutDir = layoutFile.outPath;

  keybindings = readFile ./keybindings.kdl;

  settings = toKDL { } {
    simplified_ui = true;
    pane_frames = false;
    layout_dir = layoutDir;
    copy_on_select = false;
    # default_shell = getExe config.programs.nushell.package;
  };

  zellijconfig = keybindings + "\n" + settings;

  cfg = config.homeModules.programs.cli.zellij;
in
{
  options.homeModules.programs.cli.zellij = {
    enable = mkEnableOption "zellij";
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableFishIntegration = false;
    };

    xdg.configFile."zellij/config.kdl".text = zellijconfig;
  };
}
