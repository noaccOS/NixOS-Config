{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    forEach
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.homeModules.gnome;
in
{
  options.homeModules.gnome = {
    enable = mkEnableOption "gnome customization";

    extraExtensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra extensions to enable";
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
            kimpanel
            native-window-placement
            user-themes
          ]
          ++ cfg.extraExtensions;
      in
      forEach extensions (package: {
        inherit package;
      });
  };
}
