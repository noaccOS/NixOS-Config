# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let modules = [ "personal" "gaming" "gnome" "xmonad" "development" "nvidia" "virtualization" "logitech" "canon" "tmp" ];
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
}
