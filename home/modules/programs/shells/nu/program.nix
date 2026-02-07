{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.programs.shells.nu;
  inherit (lib)
    getExe
    mkEnableOption
    mkAfter
    mkIf
    optionalString
    pipe
    ;
in
{
  options.homeModules.programs.shells.nu = {
    enable = mkEnableOption "nushell";
  };
  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      envFile.text = "";
      configFile.text = pipe ./config.nu [
        builtins.readFile
        (builtins.replaceStrings
          [
            "/usr/bin/env fish"
            "/usr/bin/env vivid"
            "/usr/bin/env zoxide"
          ]
          (
            map getExe [
              pkgs.fish
              pkgs.vivid
              pkgs.zoxide
            ]
          )
        )
      ];
    };
  };
}
