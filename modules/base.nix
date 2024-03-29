{ pkgs, currentUser, ... }:
{
  imports = [ ./cachix.nix ];

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

  home-manager.users.${currentUser.name}.homeModules.cli.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
    };
  };

  nix = {
    extraOptions = ''
      keep-outputs     = true
      keep-derivations = true
      experimental-features = nix-command flakes
      commit-lockfile-summary = chore(flake): update inputs
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
    pam.services.sudo.nodelay = true;
    pam.services.login.nodelay = true;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
      };
    };
    fwupd.enable = true;
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

  system.stateVersion = "23.11";
}
