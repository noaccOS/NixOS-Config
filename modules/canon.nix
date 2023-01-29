{ pkgs, config, ... }:
{
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    openFirewall = true;
  };
  users.users.${config.services.parameters.defaultUser}.extraGroups = [ "scanner" "lp" "avahi" ];
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };
}
