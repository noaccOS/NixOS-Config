{
  pkgs,
  lib,
  config,
  user,
  ...
}:
let
  ssh-keys = lib.filesystem.listFilesRecursive ../config/ssh-keys;
  inherit (builtins) baseNameOf head listToAttrs;
  inherit (lib)
    flip
    mkForce
    pipe
    splitString
    ;
in
{
  imports = [
    ./cachix.nix
    ./catppuccin.nix
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.shellAliases = {
    http = "xh";
    https = "xhs";
  };
  environment.shells = [ pkgs.nushell ];
  environment.systemPackages = with pkgs; [
    helix
    xq # jq
    wget
    htop
    retry
    fd # find
    ripgrep # rg (grep)
    eza # ls
    bat # cat
    tealdeer # tldr
    unzip
    git
    ffmpeg_7-full
    xh
    hwatch
  ];

  home-manager.users.${user}.homeModules.cli.enable = true;

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
    settings = {
      keep-outputs = true;
      keep-derivations = true;
      inherit (config.home-manager.users.${user}.nix.settings)
        commit-lockfile-summary
        experimental-features
        ;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings.trusted-users = [
      "root"
      user
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish = {
    enable = true;
    promptInit = "${pkgs.nix-your-shell}/bin/nix-your-shell fish | source";
  };
  programs.less.enable = mkForce false;

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
      knownHosts =
        let
          hostname = flip pipe [
            baseNameOf
            (splitString ".")
            head
          ];
        in
        pipe ssh-keys [
          (map (key: {
            name = hostname key;
            value = {
              publicKeyFile = key;
            };
          }))
          listToAttrs
        ];
    };
  };

  time.timeZone = "Europe/Rome";

  users = {
    defaultUserShell = pkgs.fish;

    groups = {
      plugdev = { };
      ${user} = { };
    };
    users.root = {
      openssh.authorizedKeys.keyFiles = ssh-keys;
      initialPassword = "password";
    };
    users.${user} = {
      isNormalUser = true;
      group = user;
      description = "Francesco Noacco";
      extraGroups = [
        "network"
        "plugdev"
        "wheel"
      ];
      openssh.authorizedKeys.keyFiles = ssh-keys;
      initialPassword = "password";
    };
  };

  system.stateVersion = "25.05";
}
