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
      alacritty.settings.import = [ theme.alacritty ];
      bat = {
        config.theme = theme.bat.name;
        themes = mkIf theme.bat.withSource {
          ${theme.bat.name} = { inherit (theme.bat) src file; };
        };
      };
      fish = {
        plugins = [ theme.fish.plugin ];
      };
      helix.settings.theme = theme.helix.name;
      rio.settings.theme = theme.rio.name;
      starship.settings = theme.starship;
    };

    xdg.configFile."rio/themes/${theme.rio.name}.toml".source = theme.rio.src;
  };
}
