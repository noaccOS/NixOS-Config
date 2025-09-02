{
  config,
  lib,
  inputs,
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
    package = inputs.anyrun.packages.${pkgs.system}.anyrun;

    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
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
