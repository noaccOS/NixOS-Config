# Original source: https://github.com/jonahbron/config/blob/main/modules/system.nix

{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce;
in
{
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.initrd.availableKernelModules = lib.mkForce [
    "usbhid"
    "md_mod"
    "raid0"
    "raid1"
    "raid10"
    "raid456"
    "ext2"
    "ext4"
    "sd_mod"
    "sr_mod"
    "mmc_block"
    "uhci_hcd"
    "ehci_hcd"
    "ehci_pci"
    "ohci_hcd"
    "ohci_pci"
    "xhci_hcd"
    "xhci_pci"
    "usbhid"
    "hid_generic"
    "hid_lenovo"
    "hid_apple"
    "hid_roccat"
    "hid_logitech_hidpp"
    "hid_logitech_dj"
    "hid_microsoft"
    "hid_cherry"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  disko = {
    imageBuilder.extraPostVM = config.hardware.rockchip.diskoExtraPostVM;
    memSize = 4096;
    devices.disk.main = {
      type = "disk";
      imageSize = "16G";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            # Firmware backoff
            start = "16M";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0022" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/";
              mountOptions = [
                "noatime"
              ];
            };
          };
        };
      };
    };
  };
}
