{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.programs.runners.anyrun;
in
{
  options.homeModules.programs.runners.anyrun = {
    enable = lib.mkEnableOption "anyrun";
    plugins = lib.mkOption {
      type = with lib.types; listOf (either package str);
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = cfg.plugins;
        ignoreExclusiveZones = false;
        # layer = "overlay";
        # hidePluginInfo = false;
        # closeOnClick = false;
        # maxEntries = null;
      };
      extraCss = ''
        .some_class {
          background: red;
        }
      '';
    };

    nix.settings = {
      substituters = [ "https://anyrun.cachix.org" ];
      trusted-public-keys = [ "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s=" ];
    };
  };
}
