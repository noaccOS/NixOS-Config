{ pkgs, user, ... }:
{
  services = {
    jellyfin.enable = true;
  };

  virtualisation = {
    podman.enable = true;
  };
  users.users.${user}.extraGroups = [ "jellyfin" "podman" ];
}
