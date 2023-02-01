{ pkgs, currentUser, ... }:
{
  imports = [ ./desktop.nix ];

  boot.kernelParams = [ "mitigations=off" ];

  environment.defaultPackages = with pkgs; [
    tdesktop
    discord-canary
  ];

  security.doas.extraRules = [
        { users  = [ currentUser ];  keepEnv = true; noPass = true; }
  ];
}
