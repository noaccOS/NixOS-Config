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
    { self, nixpkgs, rock5, home-manager, nixgl, emacs-overlay }@inputs:
    let
      makeSystem = import ./lib/makeSystem.nix inputs;
      makeHome = import ./lib/makeHome.nix inputs;
    in
    {
      nixosConfigurations = {
        mayoi = makeSystem "mayoi" {
          localModules = [
            "desktop"
            "personal"
            "gaming"
            "gnome"
            "development"
            "nvidia"
            "virtualization"
            "logitech"
            "canon"
          ];
        };

        hitagi = makeSystem "hitagi" {
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
          user = { name = "francesco"; fullName = "Francesco Noacco"; };
          localModules = [
            "desktop"
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
          x86 = makeHome { };
          arm = makeHome { system = "aarch64-linux"; };
        };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };
}
