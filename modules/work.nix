{ pkgs, config, lib, ... }:
let
  cfg = config.noaccOSModules.work;
  astartectl = pkgs.buildGoModule rec {
    pname = "astartectl";
    version = "22.11.02";
    src = pkgs.fetchFromGitHub {
      owner = "astarte-platform";
      repo = "astartectl";
      rev = "v${version}";
      sha256 = "sha256-24KzPxbewf/abzqQ7yf6HwFQ/ovJeMCrMNYDfVn5HA8=";
    };
    vendorSha256 = "sha256-RVWnkbLOXtNraSoY12KMNwT5H6KdiQoeLfRCLSqVwKQ=";
    # preBuild = ''
    #   export CGO_ENABLED=0
    # '';
  };
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
      astartectl
    ] ++ lib.optional cfg.enablePodman pkgs.podman-compose;

    users.users.tech = {
      hashedPassword = "$y$j9T$EYMiCulten0c9xEkSW59l0$IYR43m.6UjbNP9GbHI05uG.qbNYLPI5cA00s97xnWS5";
      uid = 1000;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    services.cassandra = {
      enable = true;
      package = pkgs.cassandra_4;
    };

    virtualisation.podman = {
      enable = lib.mkDefault cfg.enablePodman;
      defaultNetwork.settings.dns_enabled = true;
    };

    boot.kernel.sysctl = lib.mkIf cfg.enablePodman {
      "fs.aio-max-nr" = 1048576;
    };
  };
}
