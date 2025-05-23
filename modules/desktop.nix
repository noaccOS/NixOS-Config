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
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.noaccOSModules.desktop = {
    enable = mkEnableOption "Module for desktop computer utilities";
    ime = mkOption {
      type = types.enum [
        "ibus"
        "fcitx5"
      ];
      default = "fcitx5";
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.systemd.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    boot.kernelParams = [ "quiet" ];

    boot.loader = mkIf (currentSystem == "x86_64-linux") {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.enable = false;
    };

    boot.plymouth.enable = true;

    console.earlySetup = true;

    environment = {
      defaultPackages = with pkgs; [
        ungoogled-chromium
        xorg.xhost
        xorg.xmodmap
        pavucontrol
        mpv
        pandoc
        imagemagick
        wl-clipboard
      ];

      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      variables = {
        _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      };
    };

    fonts = {
      packages = config.home-manager.users.${user}.homeModules.gui.fontPackages;
      fontconfig = {
        inherit (config.home-manager.users.${user}.fonts.fontconfig) defaultFonts;
      };
    };

    home-manager.users.${user}.homeModules.gui.enable = true;

    i18n.inputMethod = {
      enable = true;
      type = cfg.ime;
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      fcitx5.waylandFrontend = true;
    };

    networking.networkmanager.enable = true;

    nixpkgs.config.joypixels.acceptLicense = true;

    programs = {
      adb.enable = true;
      java.enable = true;
      dconf.enable = true;
      xwayland.enable = true;
      kdeconnect.enable = true;
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
      chromium = {
        enable = true;
        extraOpts = {
          BrowserSignin = 0;
          SyncDisabled = true;
          PasswordManagerEnabled = false;
        };
      };
    };

    hardware = {
      bluetooth = {
        enable = true;
        package = pkgs.bluez-experimental;
        settings.General.Experimental = true;
        settings.General.FastConnectable = true;
        settings.General.MultiProfile = "multiple";
      };
      nitrokey.enable = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          libvdpau
          vaapiVdpau
          vulkan-validation-layers
          vulkan-extension-layer
        ];
      };

      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };

    services = {
      blueman.enable = true;
      deluge.enable = true;
      flatpak.enable = true;
      libinput.touchpad.disableWhileTyping = true;

      xserver = {
        enable = true;
        xkb.layout = "us";
        wacom.enable = true;
      };

      printing = {
        enable = true;
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };

    users.users.${user}.extraGroups = [
      "adbusers"
      "audio"
      "video"
    ];
  };
}
