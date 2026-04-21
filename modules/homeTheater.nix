{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.noaccOSModules.homeTheater;
  kodiCfg = config.home-manager.users.${user}.programs.kodi;
in
{
  options.noaccOSModules.homeTheater = {
    enable = lib.mkEnableOption "Home Theater with Kodi";
  };

  config = lib.mkIf cfg.enable {
    # use alsa; which supports hdmi passthrough
    services.pulseaudio.enable = false;
    services.pipewire.enable = false;

    home-manager.users.${user}.homeModules.homeTheater.enable = true;

    users.users.kodi = {
      initialPassword = "password";
      extraGroups = [
        # allow kodi access to keyboards
        "input"
      ];
      isNormalUser = true;
    };

    # auto-login and launch kodi
    services.getty.autologinUser = "kodi";
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${kodiCfg.package}/bin/kodi-standalone";
          user = "kodi";
        };
      };
    };
  };
}
