{
  description = "noaccOS' system config";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      makeSystem = import ./makeSystem.nix;
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
      };
    };
}
