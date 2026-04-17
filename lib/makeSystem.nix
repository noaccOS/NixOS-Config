# Inspiration from https://github.com/mitchellh/nixos-config/blob/main/flake.nix

{
  nixpkgs,
  nixpkgs-small,
  home-manager,
  cachyos-kernel,
  catppuccin,
  disko,
  mt7927,
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
  specialArgs = { inherit mt7927; };

  modules = extraModules ++ [
    (
      { config, ... }:
      {
        config._module.args = {
          pkgsSmall = import nixpkgs-small (config.nixpkgs.config // { inherit system; });
          inherit user;
          currentSystemName = name;
          currentDomainName = wan;
          currentSystem = system;
          inputs = flake-inputs;
          monitors = adjustedMonitors;
        };
      }
    )

    {
      nixpkgs.hostPlatform = system;
      nixpkgs.overlays = overlays ++ [
        cachyos-kernel.overlays.pinned
      ];

      networking.hostName = name;

      nix.channel.enable = false;
    }

    catppuccin.nixosModules.catppuccin
    disko.nixosModules.disko
    mt7927.nixosModules.default
    nix-index-database.nixosModules.nix-index

    ./lix.nix
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
        ../modules/mt7927.nix
        ../modules/nvidia.nix
        ../modules/personal.nix
        ../modules/plasma.nix
        ../modules/sbc.nix
        ../modules/server.nix
        ../modules/virtualization.nix
        ../modules/windowManager.nix
        ../modules/work.nix
      ];

      noaccOSModules = genAttrs localModules (_: {
        enable = true;
      });
    }

    (mkIf (elem "gnome" localModules) {
      noaccOSModules.gnome.barebones = false;
    })

    home-manager.nixosModules.home-manager

    (
      { pkgsSmall, ... }:
      {
        home-manager = {
          useUserPackages = true;
          users.${user} = (
            { ... }:
            {
              imports = [
                ../home/home.nix
                catppuccin.homeModules.catppuccin
                nix-index-database.homeModules.nix-index
                niri.homeModules.niri
              ];
            }
          );
          extraSpecialArgs = {
            inherit user system pkgsSmall;
            inputs = flake-inputs;
            monitors = adjustedMonitors;
          };
        };
      }
    )
  ];
}
