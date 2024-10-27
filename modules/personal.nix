{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.noaccOSModules.personal;
in
{
  options.noaccOSModules.personal = {
    enable = lib.mkEnableOption "Personal computer, with insecure settings and personal programs";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [ "mitigations=off" ];

    home-manager.users.${user}.homeModules.personal.enable = true;

    security.sudo-rs.extraRules = [
      {
        users = [ user ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
