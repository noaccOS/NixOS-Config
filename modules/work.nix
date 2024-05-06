{
  pkgs,
  config,
  lib,
  currentUser,
  ...
}:
let
  cfg = config.noaccOSModules.work;
in
{
  options.noaccOSModules.work = {
    enable = lib.mkEnableOption "Work pc programs and options";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (callPackage ../packages/copyrighter/package.nix { })
      timewarrior
      firefox
      kubectl
      (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    ];

    users.users.tech = {
      hashedPassword = "$y$j9T$EYMiCulten0c9xEkSW59l0$IYR43m.6UjbNP9GbHI05uG.qbNYLPI5cA00s97xnWS5";
      uid = 1000;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    home-manager.users.${currentUser}.programs.starship.settings.kubernetes.disabled = false;
    networking.firewall.allowedTCPPorts = [
      4000
      8080
    ];
  };
}
