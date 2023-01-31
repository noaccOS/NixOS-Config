{
  description = "noaccOS' system config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    rock5.url = "github:aciceri/rock5b-nixos";
    rock5nixpkgs.url = "rock5/nixpkgs";
  };

  # rock5 cachix
  nixConfig = {
    extra-substituters = [ "https://rock5b-nixos.cachix.org" ];
    extra-trusted-public-keys = [ "rock5b-nixos.cachix.org-1:bXHDewFS0d8pT90A+/YZan/3SjcyuPZ/QRgRSuhSPnA=" ];
  };

  outputs =
    { self, nixpkgs, rock5, rock5nixpkgs }:
    let
      makeSystem = import ./lib/makeSystem.nix;
    in {
      nixosConfigurations = {
        mayoi = makeSystem "mayoi" {
          inherit nixpkgs;
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
          nixpkgs = rock5nixpkgs;
          system = "aarch64-linux";
          extraModules = [
            rock5.nixosModules.kernel
            rock5.nixosModules.fan-control
          ];
          localModules = [
            "server"
          ];
        };
      };
    };
}
