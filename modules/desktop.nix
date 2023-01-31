{pkgs, currentUser, ...}:
{
  imports = [ ./base.nix ../services/theming.nix ];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  environment = {
    defaultPackages = with pkgs; [
      # emacs
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
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/f0fff2e0952e97a9ad733ef96e6fa7d4f3b9fafe.tar.gz";
        sha256 = "1gvrvxrl1z13rkaxvxlbqd3y3cqqs8h86r68gm52z2hzwz8vqrzv";
      }))
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
      # drivers = [ pkgs.cnijfilter2 ];
    };

    pipewire = {
      enable       = true;
      alsa.enable  = true;
      pulse.enable = true;
    };

    theming = {
      enable = true;
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
