{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/f69d81f1-99da-4808-9661-11705afa6417";
      fsType = "btrfs";
      options = [ "noatime" ];
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
      options = [ "noatime" ];
    };

  swapDevices = [ ];

  services.xserver = {
    exportConfiguration = true;
    monitorSection = ''
      VendorName     "Unknown"
      ModelName      "HPN OMEN by HP 35"
      HorizSync       73.0 - 151.0
      VertRefresh     30.0 - 100.0
      Option         "DPMS"
    '';
    screenSection = ''
      DefaultDepth    24
      Option         "Stereo" "0"
      Option         "nvidiaXineramaInfoOrder" "DFP-6"
      Option         "metamodes" "DP-1: 3440x1440_100 +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-1: 1920x1080_60 +0+360 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
      Option         "SLI" "Off"
      Option         "MultiGPU" "Off"
      Option         "BaseMosaic" "off"
    '';
  };

  services.postgresql.enable = true;

}
