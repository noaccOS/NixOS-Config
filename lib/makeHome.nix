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
      config.homeModules.cli.sourceNix = true;
      config.homeModules.nixgl = {
        enable = system == "x86_64-linux";
        driver = gpuDriver;
      };
    }
  ];

  extraSpecialArgs = {
    inherit user inputs system;
  };
}
