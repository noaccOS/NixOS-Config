{ nixpkgs, home-manager, nixgl, emacs-overlay, ... }@inputs:
{ system ? "x86_64-linux"
, user ? "noaccos"
}:
let
  mkLstIf = condition: expr: if condition then expr else [ ];
  nixglEnabled = system == "x86_64-linux";

  mkLstIfNGL = mkLstIf nixglEnabled;
in
home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    inherit system;
    overlays = mkLstIfNGL [ nixgl.overlay ];
  };
  modules = [
    ../home/home.nix
    ../home/modules/not-nixos.nix
  ] ++ mkLstIfNGL [ ../home/modules/nixgl.nix ];
  extraSpecialArgs = {
    inherit user;
    emacsPkg = emacs-overlay.packages.${system}.emacsPgtk;
  };
}
