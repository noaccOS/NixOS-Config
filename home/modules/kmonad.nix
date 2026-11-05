{
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
  cfg = config.homeModules.kmonad;
in
{
  options.homeModules.kmonad = {
    enable = mkEnableOption "KMonad";
    config = mkOption {
      type = types.path;
      description = "KMonad configuration";
    };
    gnome.enable = mkEnableOption "the KMonad toggle GNOME extension";
    dms.enable = mkEnableOption "the KMonad toggle DMS plugin";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.gnome.enable {
      programs.gnome-shell.extensions = [
        {
          package = pkgs.gnomeExtensions.kmonad-toggle.overrideAttrs {
            src = pkgs.fetchFromGitHub {
              owner = "vandalt";
              repo = "gnome-kmonad-toggle";
              rev = "4b2010cae0c2cbf11fac1ff72a69e8f1c3aca703";
              hash = "sha256-sJ/g4vbGmwXldt1DTtoXgYSpDi4FcnGoNed00ud1ETU=";
            };
          };
        }
      ];

      dconf.settings."org/gnome/shell/extensions/kmonad-toggle" = {
        autostart-kmonad = true;
        kmonad-command = "${getExe pkgs.kmonad} \"${cfg.config}\"";
      };
    })
    (mkIf cfg.dms.enable {
      programs.dank-material-shell.plugins.kmonadToggle = {
        src = inputs.dms-kmonad-toggle.packages.${system}.default;
        settings = {
          autostart = true;
          configFile = "${cfg.config}";
          kmonadPath = getExe pkgs.kmonad;
        };
      };
      homeModules.windowManagers.dms.pluginTiles = [
        {
          enabled = true;
          h = 1;
          id = "plugin_kmonadToggle";
          w = 4;
        }
      ];
    })
  ]);
}
