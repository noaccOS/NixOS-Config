{ pkgs, lib, currentUser, currentSystem, config, ... }:
let
  cfg = config.noaccOSModules.desktop;
in
{
  options.noaccOSModules.desktop = {
    enable = lib.mkEnableOption "Module for desktop computer utilities";

  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    boot.loader = lib.mkIf (currentSystem == "x86_64-linux") {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.enable = false;
    };

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

    nixpkgs = {
      config.joypixels.acceptLicense = true;
      overlays = [
        (import ../packages)
      ];
    };

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
      opengl = {
        enable = true;
        driSupport = true;
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
        layout = "us";
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

    users.users.${currentUser.name}.extraGroups = [ "adbusers" "audio" "video" ];
  };
}
