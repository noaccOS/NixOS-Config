{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.noaccOSModules.development;

  inherit (lib) mkIf;
in
{
  options.noaccOSModules.development = with lib; {
    enable = mkEnableOption "Dev tools";
  };

  config = mkIf cfg.enable {
    home-manager.users.${user}.homeModules.development.enableTools = true;

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
