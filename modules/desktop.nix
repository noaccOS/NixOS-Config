{
  pkgs,
  lib,
  user,
  currentSystem,
  config,
  ...
}:
let
  cfg = config.noaccOSModules.desktop;

  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    ;
in
{
  options.noaccOSModules.desktop = {
    enable = mkEnableOption "Module for desktop computer utilities";
  };

  config = mkIf cfg.enable {
    boot.kernelPackages = mkDefault pkgs.linuxPackages_xanmod_latest;
    boot.kernelParams = [ "quiet" ];

    boot.loader = mkIf (currentSystem == "x86_64-linux") {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.enable = false;
    };

    boot.plymouth.enable = true;
    console.earlySetup = true;

    home-manager.users.${user}.homeModules.desktop.enable = true;
    noaccOSModules.gui.enable = true;

    programs = {
      dconf.enable = true;
      xwayland.enable = true;
      kdeconnect.enable = true;
      ssh.startAgent = false;
    };

    services = {
      flatpak.enable = true;

      xserver = {
        enable = true;
        xkb.layout = "us";
        wacom.enable = true;
      };

      printing = {
        enable = true;
      };
    };
  };
}
