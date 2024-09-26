# Inspiration from https://github.com/mitchellh/nixos-config/blob/main/flake.nix

{
  nixpkgs,
  home-manager,
  catppuccin,
  kmonad,
  lix,
  ...
}@flake-inputs:
name:
{
  system ? "x86_64-linux",
  user ? "noaccos",
  wan ? "${name}.local",
  overlays ? [ ],
  localModules ? [ ],
  extraModules ? [ ],
}:
let
  lib = nixpkgs.lib;
in
lib.nixosSystem rec {
  inherit system;

  modules = extraModules ++ [
    {
      config._module.args = {
        currentSystemName = name;
        currentDomainName = wan;
        currentSystem = system;
        user = user;
        inputs = flake-inputs;
      };
    }

    {
      nixpkgs.overlays = overlays;
      networking.hostName = name;

      nix.channel.enable = false;

      programs = {
        nix-index.enable = true;
        command-not-found.enable = false;
      };
    }

    catppuccin.nixosModules.catppuccin
    kmonad.nixosModules.default
    lix.nixosModules.default

    ../modules/base.nix
    ../hosts/${name}.nix

    {
      # Load all the files, enable the chosen options at the end
      imports = [
        ../modules/canon.nix
        ../modules/desktop.nix
        ../modules/development.nix
        ../modules/docker.nix
        ../modules/gaming.nix
        ../modules/gnome.nix
        ../modules/intel.nix
        ../modules/kmonad.nix
        ../modules/logitech.nix
        ../modules/nvidia.nix
        ../modules/personal.nix
        ../modules/plasma.nix
        ../modules/server.nix
        ../modules/work.nix
        ../modules/virtualization.nix
      ];

      noaccOSModules = lib.genAttrs localModules (_: {
        enable = true;
      });
    }

    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useUserPackages = true;
        users.${user} = (
          { pkgs, ... }@inputs:
          {
            imports = [
              ../home/home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
          }
        );
        extraSpecialArgs = {
          inherit user system;
          inputs = flake-inputs;
        };
      };
    }
  ];
}
