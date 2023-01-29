{ pkgs, config, ... }:
{
  services = {
    openssh = {
      enable = true;
      ports = [ 26554 ];
     };
  
    jellyfin.enable = true;
  };

  virtualisation = {
    podman.enable = true;
  };
  users.users.${config.services.parameters.defaultUser}.extraGroups = [ "jellyfin" "podman" ];
}
