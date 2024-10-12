{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    forEach
    getExe
    mkEnableOption
    mkIf
    mkOption
    optional
    types
    ;
  cfg = config.homeModules.gnome;

  kmonad = {
    options = {
      enable = mkEnableOption "KMonad Toggle";

      config = mkOption {
        type = types.path;
        description = "KMonad configuration";
      };
    };
  };

in
{
  options.homeModules.gnome = {
    enable = mkEnableOption "gnome customization";

    extraExtensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra extensions to enable";
    };

    kmonad = mkOption {
      type = types.submodule kmonad;
      default = { };
      description = "kmonad-toggle configuration";
    };
  };

  imports = [ gnome/dconf.nix ];

  config = mkIf cfg.enable {
    home.packages = [ pkgs.gnome-tweaks ];
    homeModules.windowManagers.gnome-shell.enable = true;

    programs.gnome-shell.enable = true;
    programs.gnome-shell.extensions =
      let
        extensions =
          with pkgs.gnomeExtensions;
          [
            dash-to-dock
            fullscreen-avoider
            gsconnect
            native-window-placement
            quick-settings-tweaker
            user-themes
          ]
          ++ cfg.extraExtensions
          ++ optional cfg.kmonad.enable kmonad-toggle;
      in
      forEach extensions (package: {
        inherit package;
      });

    dconf.settings."org/gnome/shell/extensions/kmonad-toggle" = mkIf cfg.kmonad.enable {
      autostart-kmonad = true;
      kmonad-command = "${getExe pkgs.kmonad} \"${cfg.kmonad.config}\"";
    };
  };
}
