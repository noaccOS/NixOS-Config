{ pkgs, currentUser, ... }:
{
  environment.systemPackages = [ pkgs.virt-manager ];
  
  programs.dconf.enable = true;
  
  services.udev.packages = [ pkgs.qmk-udev-rules ];

  users.users.${currentUser}.extraGroups = [ "libvirtd" ];
  
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
