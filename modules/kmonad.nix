{
  config,
  user,
  home-manager,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    typeOf
    types
    ;
  cfg = config.noaccOSModules.kmonad;
in
{
  options.noaccOSModules.kmonad = {
    enable = mkEnableOption "KMonad utilities";
    serviceType = mkOption {
      description = "The type of service to enable";
      type = types.enum [
        "nixos"
        "gnome"
      ];
      default = if config.noaccOSModules.gnome.enable then "gnome" else "nixos";
    };
    configuration = mkOption {
      description = "Keyboard configuration";
      type = types.path;
      default = ../config/kmonad/${config.networking.hostName}.kbd;
    };
    serviceConfiguration = mkOption {
      description = "Configuration for the KMonad NixOS service";
      type = types.attrs; # technically a submodule, don't want to copy-paste from kmonad module.
      default = {
        config = builtins.readFile cfg.configuration;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.kmonad.enable = true;

      users.users.${user}.extraGroups = [
        "input"
        "uinput" # Created by kmonad nixos-module
      ];
    }
    (mkIf (cfg.serviceType == "nixos") {
      services.kmonad.keyboards.keyboard = cfg.serviceConfiguration;
    })
    (mkIf (cfg.serviceType == "gnome") {
      home-manager.users.${user}.homeModules = {
        gnome.kmonad = {
          enable = true;
          config = cfg.configuration;
        };
        windowManagers.niri.kmonad = {
          enable = true;
          config = cfg.configuration;
        };
      };
    })
  ]);
}
