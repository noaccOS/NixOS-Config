{
  config,
  lib,
  inputs,
  system,
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
      plugins = with inputs.anyrun.packages.${system}; [
        applications
        kidex
        randr
        rink
        shell
        stdin
        symbols
        websearch
      ];
    };
  };

}
