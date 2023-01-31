{ pkgs, currentUser, ... }:
{
  services = {
    jellyfin.enable = true;
  };

  virtualisation = {
    podman.enable = true;
  };
  users.users.${currentUser}.extraGroups = [ "jellyfin" "podman" ];
}
