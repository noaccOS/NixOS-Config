{ pkgs, ... }:
{
  imports = [ ./desktop.nix ];
  environment.defaultPackages = with pkgs; [
    tdesktop
    discord-canary
  ];
}
