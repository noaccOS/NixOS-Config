{ pkgs, config, ... }:
let defaultUser = config.services.parameters.defaultUser;
in
{
  imports = [ ./cachix.nix ../services/parameters.nix ];
  
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  
  console  = {
    font   = "Lat2-Terminus16";
    keyMap = "us";
  };
  
  environment.systemPackages = with pkgs; [
    neovim
    wget
    neofetch
    htop
    fd       # find
    ripgrep  # rg (grep)
    exa      # ls
    bat      # cat
    tealdeer # tldr
    unzip
    git
    ffmpeg_5
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME        = "en_DK.UTF-8";
      LC_MONETARY    = "en_IE.UTF-8";
      LC_PAPER       = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
    };
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc uniemoji ];
    };
  };

  nix = {
    extraOptions = ''
      keep-outputs     = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    
    settings.trusted-users = [ "root" defaultUser ];
  };

  nixpkgs.config.allowUnfree = true;
  networking.resolvconf.enable = false;
  
  programs.fish = {
    enable = true;
    promptInit = "${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source";
  };

  security = {
    rtkit.enable = true;
    sudo.enable = false;
    doas = {
      enable  = true;
      extraRules = [
        { groups = [ "wheel" ];          keepEnv = true; }
        { users  = [ defaultUser "root" ]; keepEnv = true; noPass = true; }
      ];
    };
  };
  
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  time.timeZone = "Europe/Rome";

  users = {
    defaultUserShell = pkgs.fish;

    users.${defaultUser} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "plugdev" ];
    };
  };

  environment.variables = rec {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE  = "ibus";
  };
  system.stateVersion = "22.05";
}
