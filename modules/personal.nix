{ pkgs, ... }:
{
  imports = [ ./desktop.nix ];

  boot.kernelParams = [ "mitigations=off" ];

  environment.defaultPackages = with pkgs; [
    tdesktop
    discord-canary
  ];
}
