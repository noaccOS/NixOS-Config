{ nixpkgs, home-manager, nixgl, emacs-overlay, ... }@inputs:
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

    {
      config.homeModules.cli.sourceNix = true;
      config.homeModules.nixgl = {
        enable = system == "x86_64-linux";
        driver = gpuDriver;
      };
    }
  ];

  extraSpecialArgs = {
    inherit user;
    emacsPkg = emacs-overlay.packages.${system}.emacsPgtk;
  };
}
