# Inspiration from https://github.com/mitchellh/nixos-config/blob/main/flake.nix

{
  nixpkgs,
  home-manager,
  catppuccin,
  lix,
  niri,
  nix-index-database,
  ...
}@flake-inputs:
name:
{
  system ? "x86_64-linux",
  user ? "noaccos",
  wan ? "${name}.local",
  monitors ? { },
  overlays ? [ ],
  localModules ? [ ],
  extraModules ? [ ],
}:
let
  inherit (nixpkgs.lib) nixosSystem mkIf genAttrs;
  inherit (builtins) elem;
  adjustedMonitors = import ./adjustMonitors.nix nixpkgs.lib monitors;
in
nixosSystem rec {
  inherit system;

  modules = extraModules ++ [
    {
      config._module.args = {
        inherit user;
        currentSystemName = name;
        currentDomainName = wan;
        currentSystem = system;
        inputs = flake-inputs;
        monitors = adjustedMonitors;
      };
    }

    {
      nixpkgs.overlays = overlays;
      networking.hostName = name;

      nix.channel.enable = false;
    }

    catppuccin.nixosModules.catppuccin
    lix.nixosModules.default
    nix-index-database.nixosModules.nix-index
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
          { ... }:
          {
            imports = [
              ../home/home.nix
              catppuccin.homeModules.catppuccin
              nix-index-database.hmModules.nix-index
              niri.homeModules.niri
            ];
          }
        );
        extraSpecialArgs = {
          inherit user system;
          inputs = flake-inputs;
          monitors = adjustedMonitors;
        };
      };
    }
  ];
}
