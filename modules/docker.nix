{
  config,
  lib,
  user,
  ...
}:
let
  cfg = config.noaccOSModules.docker;
in
{
  options.noaccOSModules.docker = {
    enable = lib.mkEnableOption "Docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };
    users.users.${user}.extraGroups = [
      "docker"
      "podman"
    ];
    boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
  };
}
