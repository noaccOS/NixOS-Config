# Inspiration from https://github.com/mitchellh/nixos-config/blob/main/flake.nix

{ nixpkgs, home-manager, emacs-overlay, ... }@inputs:
name: { system ? "x86_64-linux"
      , user ? { name = "noaccos"; fullName = "Francesco Noacco"; }
      , wan ? "${name}.local"
      , overlays ? [ ]
      , localModules ? [ ]
      , extraModules ? [ ]
      }:
nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = extraModules ++ [
    {
      config._module.args = {
        currentSystemName = name;
        currentDomainName = wan;
        currentSystem = system;
        currentUser = user;
      };
    }

    {
      nixpkgs.overlays = overlays ++ [ emacs-overlay.overlays.default ];
      networking.hostName = name;
    }

    ../modules/base.nix
    ../hosts/${name}.nix

    {
      # Load all the files, enable the chosen options at the end
      imports = [
        ../modules/canon.nix
        ../modules/desktop.nix
        ../modules/development.nix
        ../modules/gaming.nix
        ../modules/gnome.nix
        ../modules/intel.nix
        ../modules/logitech.nix
        ../modules/nvidia.nix
        ../modules/personal.nix
        ../modules/plasma.nix
        ../modules/server.nix
        ../modules/sway.nix
        ../modules/work.nix
        ../modules/virtualization.nix
        ../modules/xmonad.nix
      ];

      noaccOSModules = builtins.listToAttrs (nixpkgs.lib.forEach localModules (m: { name = m; value = { enable = true; }; }));
    }

    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useUserPackages = true;
        users.${user.name} = ({ pkgs, ... }@inputs:
          (import ../home/home.nix inputs) //
            {
              homeModules = {
                cli.enable = true;
                gui.enable = true;
                theming.enable = true;
                theming.theme = "catppuccin";
                programs.emacs.package = emacs-overlay.packages.${system}.emacs-pgtk;
              };
            });
        extraSpecialArgs = {
          inherit user;
        };
      };
    }
  ];
}
