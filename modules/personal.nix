{
  pkgs,
  user,
  lib,
  config,
  ...
}:
let
  cfg = config.noaccOSModules.personal;
in
{
  options.noaccOSModules.personal = {
    enable = lib.mkEnableOption "Personal computer, with insecure settings and messaging apps";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [ "mitigations=off" ];

    environment.defaultPackages = with pkgs; [ tdesktop ];

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
