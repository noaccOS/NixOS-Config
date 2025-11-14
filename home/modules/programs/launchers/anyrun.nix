{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.homeModules.programs.launchers.anyrun;

in
{
  options.homeModules.programs.launchers.anyrun = {
    enable = mkEnableOption "anyrun";
  };

  config.programs.anyrun = {
    enable = cfg.enable;

    config = {
      plugins =
        let
          plugins = [
            "applications"
            "kidex"
            "randr"
            "rink"
            "shell"
            "stdin"
            "symbols"
            "websearch"
          ];
        in
        map (plugin: "${pkgs.anyrun}/lib/lib${plugin}.so") plugins;
    };
  };

}
