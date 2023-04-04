{
  description = "NixOS and Home-Manager configuration";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    rock5 = {
      url = "github:aciceri/rock5b-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, rock5, home-manager, nixgl, emacs-overlay }:
    let
      makeSystem = import ./lib/makeSystem.nix;
      makeHome   = import ./lib/makeHome.nix;
    in {
      nixosConfigurations = {
        mayoi = makeSystem "mayoi" {
          inherit nixpkgs home-manager emacs-overlay;
          system = "x86_64-linux";
          localModules = [
            "personal"
            "gaming"
            "gnome"
            "xmonad"
            "development"
            "nvidia"
            "virtualization"
            "logitech"
            "canon"
          ];
        };

        hitagi = makeSystem "hitagi" {
          inherit nixpkgs home-manager emacs-overlay;
          system = "aarch64-linux";
          wan = "noaccos.ovh";
          extraModules = [
            rock5.nixosModules.kernel
            rock5.nixosModules.fan-control
          ];
          localModules = [
            "server"
          ];
        };

       kaiki = makeSystem "kaiki" {
          inherit nixpkgs home-manager emacs-overlay;
          system = "x86_64-linux";
          user = "francesco";
          localModules = [
            "work"
            "intel"
            "gnome"
            "development"
            "virtualization"
          ];
        };
      };

      homeConfigurations =
      {
        x86 = makeHome {
          inherit nixpkgs home-manager nixgl emacs-overlay;
          system = "x86_64-linux";
        };
        arm = makeHome {
          inherit nixpkgs home-manager nixgl emacs-overlay;
          system = "aarch64-linux";
        };
      };
    };
}
 
