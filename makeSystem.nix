# Inspiration from https://github.com/mitchellh/nixos-config/blob/main/flake.nix

name: { nixpkgs
      , system
      , user ? "noaccos"
      , overlays ? []
      , localModules ? []
      }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = (map (m: ./modules + "/${m}.nix") localModules) ++ [
    { nixpkgs.overlays = overlays; }

    ./hosts/${name}.nix

    { networking.hostName = name; }

    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
        currentUser = user;
      };
    }
  ];
}
