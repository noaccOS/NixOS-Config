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
    types
    ;
  cfg = config.noaccOSModules.kmonad;
in
{
  options.noaccOSModules.kmonad = {
    enable = mkEnableOption "KMonad utilities";
    systemd.enable = mkOption {
      description = "Run KMonad as a NixOS service";
      type = types.bool;
      default = !(cfg.gnome.enable || cfg.dms.enable);
      defaultText = "!(gnome.enable || dms.enable)";
    };
    gnome.enable = mkEnableOption "the KMonad toggle GNOME extension";
    dms.enable = mkEnableOption "the KMonad toggle DMS plugin";
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
        "uinput" # Created by kmonad nixos-module
      ];

      home-manager.users.${user}.homeModules.kmonad = {
        enable = true;
        inherit (cfg) gnome dms;
        config = cfg.configuration;
      };

      assertions = [
        {
          assertion = !(cfg.systemd.enable && (cfg.gnome.enable || cfg.dms.enable));
          message = "noaccOSModules.kmonad: the NixOS service grabs the keyboard, so it can't be combined with the GNOME or DMS toggles.";
        }
      ];
    }
    (mkIf cfg.systemd.enable {
      services.kmonad.keyboards.keyboard = cfg.serviceConfiguration;
    })
  ]);
}
