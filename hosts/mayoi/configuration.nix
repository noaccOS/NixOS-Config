# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let modules = [ "desktop" "gaming" "gnome" "nvidia" "virtualization" ];
in
{
  imports =
    (map ( m: ./modules + "/${m}.nix" ) modules) ++
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
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };
}

