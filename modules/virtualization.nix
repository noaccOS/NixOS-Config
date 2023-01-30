{ pkgs, user, ... }:
{
  environment.systemPackages = [ pkgs.virt-manager ];
  
  programs.dconf.enable = true;
  
  services.udev.packages = [ pkgs.qmk-udev-rules ];

  users.users.${user}.extraGroups = [ "libvirtd" ];
  
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
