# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let modules = [ "personal" "gaming" "gnome" "xmonad" "development" "nvidia" "virtualization" "logitech" "tmp" ];
in
{
  imports =
    (map ( m: ../../modules + "/${m}.nix" ) modules) ++
    [ 
      ./hardware-configuration.nix
    ];

  networking = {
    hostName = "mayoi";
    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" ];
  };

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
    Option         "metamodes" "DP-4: 3440x1440_100 +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-0: 1920x1080_60 +0+360 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "off"
  '';
  };
  virtualisation = {
    podman.enable = true;
    podman.enableNvidia = true;
  };
}
