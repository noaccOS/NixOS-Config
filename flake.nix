{
  description = "noaccOS' system config";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs =
    let
      makeSystem = import ./makeSystem.nix;
    in
    { self, nixpkgs }: {
    nixosConfigurations = {
      mayoi = makeSystem "mayoi" {
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
