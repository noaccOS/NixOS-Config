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

  userConfig = config.home-manager.users.${user};
in
{
  imports = [
    ./catppuccin.nix
  ];

  boot.kernel.sysctl."fs.aio-max-nr" = 2097152;

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
    # TODO: restore to xq once gcc15 build is fixed
    jq # jq
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
    extraLocales = [
      "ja_JP.UTF-8/UTF-8"
      "en_IE.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_TIME = "ja_JP.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
    };
  };

  nix = {
    settings = {
      keep-outputs = true;
      keep-derivations = true;
      inherit (userConfig.nix.settings)
        commit-lockfile-summary
        experimental-features
        extra-substituters
        trusted-public-keys
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

  programs.fish.enable = true;
  programs.less.enable = mkForce false;

  security = {
    rtkit.enable = true;
    sudo.enable = false;
    pam = {
      services.sudo.nodelay = true;
      services.login.nodelay = true;

      loginLimits = [
        {
          domain = "*";
          type = "soft";
          item = "nofile";
          value = "8192";
        }
      ];
    };
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

  system.stateVersion = "25.11";
}
