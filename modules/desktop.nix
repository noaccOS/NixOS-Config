{pkgs, ...}:
{
  imports = [ ./base.nix ../services/theming.nix ];
  
  boot.kernelPackages = pkgs.linuxPackages_xanmod;

  environment = {
    defaultPackages = with pkgs; [
      # emacs
      ungoogled-chromium
      wezterm
      xorg.xhost
      xorg.xmodmap
      pavucontrol
      tdesktop
      discord
      mpv
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
  };
  
  hardware.pulseaudio.enable = false;
  services = {
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
        defaultTheme = "numix";
        installAll = true;
      };
      users         = [ "root" "noaccos" ];
      manualTheming = true;
    };
  };
}
