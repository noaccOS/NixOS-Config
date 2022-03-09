{ pkgs, ... }:
{
  imports = [ ./cachix.nix ];
  
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
    fd       #find
    ripgrep  #rg (grep)
    exa      #ls
    bat      #cat
    tealdeer #tldr
    git
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
    };
  };

  nix = {
    extraOptions = ''
      keep-outputs     = true
      keep-derivations = true
    '';
    settings.trusted-users = [ "root" "noaccos" ];
  };

  nixpkgs.config.allowUnfree = true;
  
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
        { users  = [ "noaccos" "root" ]; keepEnv = true; noPass = true; }
      ];
    };
  };

  time.timeZone = "Europe/Rome";

  users = {
    defaultUserShell = pkgs.fish;

    users.noaccos = {
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "video" "adbusers" "libvirtd" "plugdev" ];
    };
  };

  environment.variables = rec {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE  = "ibus";
  };
  system.stateVersion = "21.05";
}
