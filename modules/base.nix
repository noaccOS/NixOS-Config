{ pkgs, currentUser, ... }:
{
  imports = [ ./cachix.nix ../services/parameters.nix ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    neofetch
    htop
    fd # find
    ripgrep # rg (grep)
    eza # ls
    bat # cat
    tealdeer # tldr
    unzip
    git
    ffmpeg_6-full
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
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

    settings.trusted-users = [ "root" currentUser.name ];
  };

  nixpkgs.config.allowUnfree = true;
  networking.resolvconf.enable = false;

  programs.fish = {
    enable = true;
    promptInit = "${pkgs.nix-your-shell}/bin/nix-your-shell fish | source";
  };

  security = {
    rtkit.enable = true;
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
      };
    };
    openssh = {
      enable = true;
      knownHosts = {
        mayoi.publicKeyFile = ../config/ssh-keys/mayoi.pub;
        shinobu.publicKeyFile = ../config/ssh-keys/shinobu.pub;
        yotsugi.publicKeyFile = ../config/ssh-keys/yotsugi.pub;
      };
    };
  };

  time.timeZone = "Europe/Rome";

  users =
    let
      allowedKeys = [
        ../config/ssh-keys/mayoi.pub
        ../config/ssh-keys/shinobu.pub
        ../config/ssh-keys/yotsugi.pub
      ];
    in
    {
      defaultUserShell = pkgs.fish;

      groups = {
        plugdev = { };
        ${currentUser.name} = { };
      };
      users.root = {
        openssh.authorizedKeys.keyFiles = allowedKeys;
        initialPassword = "password";
      };
      users.${currentUser.name} = {
        isNormalUser = true;
        group = currentUser.name;
        description = currentUser.fullName;
        extraGroups = [ "wheel" "plugdev" ];
        openssh.authorizedKeys.keyFiles = allowedKeys;
        initialPassword = "password";
      };
    };

  environment.variables = rec {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE = "ibus";
  };

  system.stateVersion = "23.11";
}
