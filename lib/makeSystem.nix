# Inspiration from https://github.com/mitchellh/nixos-config/blob/main/flake.nix

name: { nixpkgs
      , home-manager
      , emacs-ng
      , system
      , user ? "noaccos"
      , wan ? "${name}.local"
      , overlays ? []
      , localModules ? []
      , extraModules ? []
      }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = (map (m: ../modules + "/${m}.nix") localModules) ++ extraModules ++ [
    { nixpkgs.overlays = overlays ++ [ emacs-ng.overlay ]; }

    ../hosts/${name}.nix

    { networking.hostName = name; }

    {
      config._module.args = {
        currentSystemName = name;
        currentDomainName = wan;
        currentSystem = system;
        currentUser = user;
      };
    }

    home-manager.nixosModules.home-manager {
      home-manager = {
        useUserPackages = true;
        users.${user} = import ../home/home.nix;
        extraSpecialArgs = {
          inherit user;
        };
      };
    }
  ];
}
