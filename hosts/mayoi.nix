{
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.kernelParams = [
    "amd_pstate=active"
    "clearcpuid=avx"
    "clearcpuid=avx2"
    "clearcpuid=sha"
  ];

  hardware.cpu.amd.updateMicrocode = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7104ef43-c712-4896-9b83-2b90e0cb82be";
    fsType = "btrfs";
    options = [
      "defaults"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/19C1-0600";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/9c50037a-c4d0-4c5e-9c8d-90f5d5ee7ec8";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
    ];
  };

  swapDevices = [ { device = "/swapfile"; } ];
}
