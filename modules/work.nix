{ pkgs, config, lib, ... }:
let
  cfg = config.noaccOSModules.work;
in
{
  options.noaccOSModules.work = {
    enable = lib.mkEnableOption "Work pc programs and options";
  };

  config = lib.mkIf cfg.enable {

    environment.defaultPackages = with pkgs; [
      firefox
    ];

    users.users.tech = {
      hashedPassword = "$y$j9T$EYMiCulten0c9xEkSW59l0$IYR43m.6UjbNP9GbHI05uG.qbNYLPI5cA00s97xnWS5";
      uid = 1000;
      isNormalUser = true;
    };
  };


}
