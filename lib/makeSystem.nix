# Inspiration from https://github.com/mitchellh/nixos-config/blob/main/flake.nix

name: { nixpkgs
      , system
      , user ? "noaccos"
      , wan ? "${name}.local"
      , extraWan ? []
      , overlays ? []
      , localModules ? []
      , extraModules ? []
      }:

nixpkgs.lib.nixosSystem rec {
  inherit system;

  modules = (map (m: ../modules + "/${m}.nix") localModules) ++ extraModules ++ [
    { nixpkgs.overlays = overlays; }

    ../hosts/${name}.nix

    { networking.hostName = name; }

    {
      config._module.args = {
        currentSystemName = name;
        currentSystem = system;
        currentUser = user;

        primaryDomain = wan;
        extraDomains = extraWan;
      };
    }
  ];
}
