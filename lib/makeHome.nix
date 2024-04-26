{ nixpkgs, home-manager, nixgl, emacs-overlay, catppuccin, ... }@inputs:
{ system ? "x86_64-linux"
, user ? "noaccos"
, gpuDriver ? "mesa"
}:
home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ nixgl.overlay ];
  };
  modules = [
    ../home/home.nix

    catppuccin.homeManagerModules.catppuccin

    {
      catppuccin.enable = true;
      catppuccin.flavour = "mocha";
      catppuccin.accent = "lavender";

      homeModules.cli.sourceNix = true;
      homeModules.nixgl = {
        enable = system == "x86_64-linux";
        driver = gpuDriver;
      };
    }
  ];

  extraSpecialArgs = {
    inherit user inputs system;
  };
}
