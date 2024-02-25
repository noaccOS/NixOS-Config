{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  hardware.cpu.amd.updateMicrocode = true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/f69d81f1-99da-4808-9661-11705afa6417";
      fsType = "btrfs";
      options = [ "defaults" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/19C1-0600";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/9c50037a-c4d0-4c5e-9c8d-90f5d5ee7ec8";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
    };

  swapDevices = [ ];
}
