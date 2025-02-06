{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeModules.work;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.homeModules.work.enable = mkEnableOption "work configuration";
  config = mkIf cfg.enable {
    programs.starship.settings.kubernetes.disabled = false;

    homeModules.gnome.extraExtensions = with pkgs.gnomeExtensions; [
      paperwm
      unblank
    ];
  };
}
