{ pkgs, user, ... }:
{
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    openFirewall = true;
  };
  users.users.${user}.extraGroups = [ "scanner" "lp" "avahi" ];
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };
}
