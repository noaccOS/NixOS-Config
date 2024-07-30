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
    kmonad = mkOption {
      type = types.submodule kmonad;
      description = "kmonad-toggle configuration";
    };
  };

  imports = [ gnome/dconf.nix ];

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.adw-gtk3
      pkgs.celluloid
      pkgs.gnome-tweaks
      pkgs.nautilus-python
    ];

    homeModules.programs.browsers.firefox.gnomeIntegration = true;

    programs.gnome-shell.enable = true;
    programs.gnome-shell.extensions =
      let
        extensions = [
          pkgs.gnomeExtensions.dash-to-dock
          pkgs.gnomeExtensions.gsconnect
          pkgs.gnomeExtensions.native-window-placement
          pkgs.gnomeExtensions.quick-settings-tweaker
          pkgs.gnomeExtensions.user-themes
        ] ++ optional cfg.kmonad.enable pkgs.gnomeExtensions.kmonad-toggle;
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
