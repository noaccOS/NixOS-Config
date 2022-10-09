{ pkgs, ... }:
{
  hardware.sane.enable = true;
  hardware.sane.netConf = "192.168.1.2";
  users.users.noaccos.extraGroups = [ "scanner" "lp" "avahi" ];
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };
}
