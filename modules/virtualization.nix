{ pkgs, currentUser, config, lib, ... }:
let
  cfg = config.noaccOSModules.virtualization;
in
{
  options.noaccOSModules.virtualization = {
    enable = lib.mkEnableOption "QMK configuration";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.virt-manager ];

    programs.dconf.enable = true;

    services.udev.packages = [ pkgs.qmk-udev-rules ];

    users.users.${currentUser.name}.extraGroups = [ "libvirtd" ];

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };
  };
}
