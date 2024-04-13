{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.homeModules.theming;
  theme = pkgs.callPackage ./themes/${cfg.theme.name}.nix { inherit inputs; inherit (cfg.theme) variant; };
in
with lib; {
  options.homeModules.theming = {
    enable = mkEnableOption "custom theming";
    theme = mkOption {
      type = types.submodule {
        options = {
          name = mkOption { type = types.enum [ "catppuccin" ]; default = "catppuccin"; };
          variant = mkOption {
            type = types.nullOr types.str;
            description = "theme variant (eg \"mocha\" for catppuccin mocha). null when theme does not have variants.";
            default = null;
          };
        };
      };
      default = { name = "catppuccin"; variant = "mocha"; };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      rio.settings.theme = theme.rio.name;
    };

    xdg.configFile."rio/themes/${theme.rio.name}.toml".source = theme.rio.src;
  };
}
