{pkgs, ...}:
{
  imports = [ ./base.nix ../services/theming.nix ];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  environment = {
    defaultPackages = with pkgs; [
      # emacs
      ungoogled-chromium
      wezterm
      xorg.xhost
      xorg.xmodmap
      pavucontrol
      tdesktop
      discord-canary
      mpv
      ffmpeg_5

      spotify-adblock
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
      jetbrains-mono
      symbola
      emacs-all-the-icons-fonts

      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif     = [ "Noto Sans" ];
	      sansSerif = [ "Noto Sans" ];
	      monospace = [ "JetBrains Mono" ];
      };
    };
  };

  nixpkgs = {
    config.joypixels.acceptLicense = true;
    overlays = [
      (import ../packages)
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";    
      }))
    ];
  };
  
  programs = {
    adb.enable  = true;
    java.enable = true;
    xwayland.enable = true;
    kdeconnect.enable = true;
  };
  
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  services = {
    blueman.enable = true;
    xserver = {
      enable       = true;
      layout       = "us";
      wacom.enable = true;
    };
    
    printing = {
      enable  = true;
      drivers = [ pkgs.cnijfilter2 ];
    };

    pipewire = {
      enable       = true;
      alsa.enable  = true;
      pulse.enable = true;
    };

    theming = {
      enable        = true;
      theme = {
        defaultTheme = "dracula";
        installAll = true;
      };
      icons = {
        defaultTheme = "tela";
        installAll = true;
      };
    };
  };
}
