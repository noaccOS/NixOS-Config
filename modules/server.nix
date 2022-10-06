{ pkgs, ... }:
{
  services = {
    openssh = {
      enable = true;
      ports = [ 26554 ];
     };
  
    jellyfin.enable = true;
  };
  
  users.users.noaccos.extraGroups = [ "jellyfin" ];
}
