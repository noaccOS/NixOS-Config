{ pkgs, config, ... }:
{
  environment.systemPackages = [ pkgs.virt-manager ];
  
  programs.dconf.enable = true;
  
  services.udev.packages = [ pkgs.qmk-udev-rules ];

  users.users.${config.services.parameters.defaultUser}.extraGroups = [ "libvirtd" ];
  
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
