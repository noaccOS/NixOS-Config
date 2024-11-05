# Inspiration from https://github.com/mitchellh/nixos-config/blob/main/flake.nix

{
  nixpkgs,
  home-manager,
  anyrun,
  catppuccin,
  niri,
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
  inherit (nixpkgs.lib) nixosSystem mkIf genAttrs;
  inherit (builtins) elem;
in
nixosSystem rec {
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
    # niri.nixosModules.niri

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
        ../modules/windowManager.nix
      ];

      noaccOSModules = genAttrs localModules (_: {
        enable = true;
      });
    }

    (mkIf (elem "gnome" localModules) {
      noaccOSModules.gnome.barebones = false;
    })

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
              anyrun.homeManagerModules.default
              niri.homeModules.niri
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
