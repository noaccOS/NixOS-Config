{pkgs, ...}:
{
  environment.defaultPackages = [ pkgs.piper ];
  services.ratbagd.enable = true;
}
