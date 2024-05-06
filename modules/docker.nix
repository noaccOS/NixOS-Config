{
  pkgs,
  config,
  lib,
  currentUser,
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
    users.users.${currentUser}.extraGroups = [
      "docker"
      "podman"
    ];
    boot.kernel.sysctl = {
      "fs.aio-max-nr" = 1048576;
      "net.ipv4.ip_unprivileged_port_start" = 80;
    };
  };
}
