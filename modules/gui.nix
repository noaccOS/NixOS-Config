{
  pkgs,
  lib,
  user,
  config,
  ...
}:
let
  cfg = config.noaccOSModules.gui;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.noaccOSModules.gui = {
    enable = mkEnableOption "Module for gui components";
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

    environment = {
      defaultPackages = with pkgs; [
        ungoogled-chromium
        xhost
        xmodmap
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
      fontDir.enable = true;
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

    programs = {
      dconf.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    hardware = {
      nitrokey.enable = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          libvdpau
          libva-vdpau-driver
          vulkan-validation-layers
          vulkan-extension-layer
        ];
      };
    };

    services = {
      blueman.enable = true;
      deluge.enable = true;
      libinput.touchpad.disableWhileTyping = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    };

    users.users.${user}.extraGroups = [
      "adbusers"
      "audio"
      "input"
      "video"
    ];
  };
}
