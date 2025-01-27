{
  description = "NixOS and Home-Manager configuration";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # rock5 = {
    #   url = "github:aciceri/rock5b-nixos";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    rycee = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty";

    # Overrides
    mutter-triple-buffer = {
      type = "gitlab";
      owner = "Community%2FUbuntu";
      repo = "mutter";
      ref = "triple-buffering-v4-47";
      host = "gitlab.gnome.org";
      flake = false;
    };

    # Theming
    catppuccin.url = "github:catppuccin/nix";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      ...
    }@inputs:
    let
      makeSystem = import ./lib/makeSystem.nix inputs;
      makeHome = import ./lib/makeHome.nix inputs;
    in
    {
      nixosConfigurations = {
        mayoi = makeSystem "mayoi" {
          localModules = [
            "desktop"
            "docker"
            "personal"
            "gaming"
            "development"
            "nvidia"
            "virtualization"
            "windowManager"
            "logitech"
            "canon"
          ];
          monitors = {
            "DP-1" = {
              mode = {
                x = 3440;
                y = 1440;
                hz = 100;
              };
            };
            "HDMI-A-1" = {
              mode = {
                x = 1920;
                y = 1080;
              };
              position = {
                x = -1920;
                y = 360;
              };
            };
          };

        };

        nadeko = makeSystem "nadeko" {
          localModules = [
            "desktop"
            "personal"
            "gnome"
            "development"
            "virtualization"
          ];
        };

        ougi = makeSystem "ougi" {
          localModules = [
            "desktop"
            "personal"
            "gaming"
            "docker"
            "gnome"
            "development"
            "kmonad"
            "virtualization"
            "windowManager"
          ];

          monitors."eDP-1".mode = {
            x = 2256;
            y = 1504;
          };

          extraModules = [ nixos-hardware.nixosModules.framework-13-7040-amd ];
        };

        # hitagi = makeSystem "hitagi" {
        #   inherit nixpkgs home-manager emacs-overlay;
        #   system = "aarch64-linux";
        #   wan = "noaccos.ovh";
        #   extraModules = [
        #     rock5.nixosModules.kernel
        #     rock5.nixosModules.fan-control
        #   ];
        #   localModules = [
        #     "server"
        #   ];
        # };

        kaiki = makeSystem "kaiki" {
          user = "francesco";
          monitors = {
            "DP-1" = {
              mode = {
                x = 3870;
                y = 2160;
              };
            };
            "DP-2" = {
              mode = {
                x = 3870;
                y = 2160;
              };
              position = {
                x = -2160;
                y = 0;
              };
            };
          };
          localModules = [
            "desktop"
            "windowManager"
            "work"
            "docker"
            "intel"
            "development"
            "virtualization"
          ];
        };
      };

      homeConfigurations = {
        x86 = makeHome { };
        arm = makeHome { system = "aarch64-linux"; };
      };

      templates = {
        rust = {
          description = "Rust project flake with crane and flake-parts";
          path = ./templates/rust;
        };
        rust-gpu = {
          description = "Rust project flake with crane and flake-parts, for running graphical projects for wayland";
          path = ./templates/rust-gpu;
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
