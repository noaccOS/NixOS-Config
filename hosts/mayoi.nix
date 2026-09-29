{
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "nvme"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  hardware.cpu.intel.updateMicrocode = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8d65db62-39a9-4278-811c-d8db8eb81777";
    fsType = "btrfs";
    options = [
      "defaults"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/68A4-BBBE";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/e01f1432-a7c1-4a4a-a910-5e4749545637";
    fsType = "btrfs";
    options = [
      "defaults"
      "noatime"
    ];
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/9c50037a-c4d0-4c5e-9c8d-90f5d5ee7ec8";
    fsType = "ext4";
    options = ["defaults" "noatime"];
  };

  swapDevices = [ { device = "/swapfile"; } ];
}
