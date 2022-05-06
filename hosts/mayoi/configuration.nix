# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let modules = [ "desktop" "gaming" "gnome" "xmonad" "development" "nvidia" "sway" "virtualization" "tmp" ];
in
{
  imports =
    (map ( m: ../../modules + "/${m}.nix" ) modules) ++
    [ 
      ./hardware-configuration.nix
    ];

  networking = {
    hostName = "mayoi";
    useDHCP  = false;
    useNetworkd = true;
    interfaces.enp39s0.ipv4.addresses = [{
      address = "192.168.1.10";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" ];
  };

  swapDevices = [ { device = "/var/swap"; size = 8192; } ];

  services.openssh = {
    enable = true;
    ports = [ 26554 ];
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
  services.flatpak.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };
}

