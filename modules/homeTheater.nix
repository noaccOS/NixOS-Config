{
  config,
  lib,
  user,
  ...
}:
let
  inherit (lib) getExe';

  cfg = config.noaccOSModules.homeTheater;
  kodiCfg = config.home-manager.users.${user}.programs.kodi;
  kodiBin = getExe' kodiCfg.package "kodi";
  niriCfg = config.home-manager.users.${user}.programs.niri;
  niriBin = getExe' niriCfg.package "niri-session";
in
{
  options.noaccOSModules.homeTheater = {
    enable = lib.mkEnableOption "Home Theater with Kodi";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user}.homeModules = {
      homeTheater.enable = true;
      windowManagers.niri.extraConfigPre = ''
        spawn-at-startup "${kodiBin}"
      '';
    };

    noaccOSModules.desktop.enable = true;

    # Temporarily use niri
    noaccOSModules.windowManager = {
      enable = true;
      primary = false;
    };

    # auto-login and launch kodi
    programs.regreet.enable = true;
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          inherit user;
          command = niriBin;
        };
      };
    };
  };
}
