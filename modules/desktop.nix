{
  pkgs,
  lib,
  currentUser,
  currentSystem,
  config,
  ...
}:
let
  cfg = config.noaccOSModules.desktop;
in
{
  options.noaccOSModules.desktop = {
    enable = lib.mkEnableOption "Module for desktop computer utilities";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.systemd.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    boot.kernelParams = [ "quiet" ];

    boot.loader = lib.mkIf (currentSystem == "x86_64-linux") {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.enable = false;
    };

    boot.plymouth.enable = true;

    environment = {
      defaultPackages = with pkgs; [
        libsForQt5.breeze-qt5
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
        XCURSOR_THEME = "breeze_cursors";
        _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      };
    };

    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk # Chinese, Japanese, Korean
        roboto
        joypixels
        symbola

        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      fontconfig = {
        defaultFonts = {
          emoji = [ "JoyPixels" ];
          serif = [ "Noto Sans" ];
          sansSerif = [ "Noto Sans" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
        };
      };
    };

    home-manager.users.${currentUser}.homeModules.gui.enable = true;

    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
      # fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
      # fcitx5.waylandFrontend = true;
    };

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
        package = pkgs.bluez5-experimental;
        settings.General.Experimental = true;
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
      pulseaudio.enable = false;

      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };

    services = {
      blueman.enable = true;
      deluge.enable = true;
      flatpak.enable = true;

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

    users.users.${currentUser}.extraGroups = [
      "adbusers"
      "audio"
      "video"
    ];
  };
}
