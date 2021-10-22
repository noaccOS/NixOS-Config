{pkgs, ...}:
{
  imports = [ ./base.nix ];
  
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

      libsForQt5.qtstyleplugin-kvantum
    ];

    variables = {
      XCURSOR_THEME = "breeze_cursors";
      QT_STYLE_OVERRIDE = "kvantum";
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

  nixpkgs.config.joypixels.acceptLicense = true;
  
  programs = {
    adb.enable  = true;
    java.enable = true;
  };

  qt5.enable = false;
  
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
  };
}
