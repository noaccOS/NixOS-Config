{ pkgs, lib, currentUser, currentSystem, ... }:
{
  imports = [ ./base.nix ../services/theming.nix ];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  boot.loader = lib.mkIf (currentSystem == "x86_64-linux") {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  environment = {
    defaultPackages = with pkgs; [
      libsForQt5.breeze-qt5
      ungoogled-chromium
      wezterm
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
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk # Chinese, Japanese, Korean
      roboto
      joypixels
      symbola
      emacs-all-the-icons-fonts

      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        emoji     = [ "JoyPixels" ];
        serif     = [ "Noto Sans" ];
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
    adb.enable  = true;
    java.enable = true;
    dconf.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  hardware = {
    bluetooth.enable  = true;
    nitrokey.enable   = true;
    pulseaudio.enable = false;
  };

  services = {
    blueman.enable = true;
    deluge.enable  = true;
    flatpak.enable = true;
    
    xserver = {
      enable       = true;
      layout       = "us";
      wacom.enable = true;
    };
    
    printing = {
      enable  = true;
    };

    pipewire = {
      enable       = true;
      alsa.enable  = true;
      pulse.enable = true;
    };

    theming = {
      # enable = true;
      theme = {
        defaultTheme = "catppuccin";
        installAll = true;
      };
      icons = {
        defaultTheme = "papirus";
        installAll = true;
      };
    };

    udev.packages = [ pkgs.nitrokey-udev-rules ];
  };

  users.users.${currentUser}.extraGroups = [ "adbusers" "audio" "video" ];
}
