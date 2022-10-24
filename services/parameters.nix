{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.services.parameters;
in
{
  options.services.parameters = {
      defaultUser = mkOption {
      type = types.string;
      default = "noaccos";
      description = ''
        Default user account for installation
      '';
    };
  };
}
