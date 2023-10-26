{ pkgs, config, lib, currentUser, ... }:
let
  cfg = config.noaccOSModules.work;
in
{
  options.noaccOSModules.work = {
    enable = lib.mkEnableOption "Work pc programs and options";
    enablePodman = lib.mkEnableOption "Container support";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      timewarrior
      firefox
      kubectl
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    ] ++ lib.optional cfg.enablePodman pkgs.podman-compose;

    users.users.tech = {
      hashedPassword = "$y$j9T$EYMiCulten0c9xEkSW59l0$IYR43m.6UjbNP9GbHI05uG.qbNYLPI5cA00s97xnWS5";
      uid = 1000;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    virtualisation.docker = {
      enable = lib.mkDefault cfg.enablePodman;
      enableOnBoot = false;
    };

    networking.firewall.allowedTCPPorts = [ 4000 8080 ];

    users.users.${currentUser.name}.extraGroups = [ "docker" "podman" ];

    boot.kernel.sysctl = lib.mkIf cfg.enablePodman {
      "fs.aio-max-nr" = 1048576;
      "net.ipv4.ip_unprivileged_port_start" = 80;
    };
  };
}
