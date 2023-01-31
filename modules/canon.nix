{ pkgs, currentUser, ... }:
{
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    openFirewall = true;
  };
  users.users.${currentUser}.extraGroups = [ "scanner" "lp" "avahi" ];
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };
}
