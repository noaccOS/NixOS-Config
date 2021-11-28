{ config, pkgs, ... }:
{
  imports = [ ./home.nix ./modules/not-nixos.nix ];
}
