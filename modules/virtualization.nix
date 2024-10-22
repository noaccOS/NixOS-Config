{
  pkgs,
  user,
  config,
  lib,
  ...
}:
let
  cfg = config.noaccOSModules.virtualization;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.noaccOSModules.virtualization = {
    enable = mkEnableOption "QMK configuration";
    qemu-frontend = mkOption {
      type = types.package;
      description = "The frontend to use for qemu";
      default = pkgs.virt-manager;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.qemu-frontend ];

    programs.dconf.enable = true;

    services.udev.packages = [ pkgs.qmk-udev-rules ];

    users.users.${user}.extraGroups = [ "libvirtd" ];

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };
  };
}
