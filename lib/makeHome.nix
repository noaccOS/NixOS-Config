{
  nixpkgs,
  home-manager,
  emacs-overlay,
  catppuccin,
  ...
}@inputs:
{
  system ? "x86_64-linux",
  user ? "noaccos",
  gpuDriver ? "mesa",
}:
home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs { inherit system; };
  modules = [
    ../home/home.nix

    catppuccin.homeManagerModules.catppuccin

    {
      homeModules.cli.sourceNix = true;
    }
  ];

  extraSpecialArgs = {
    inherit user inputs system;
  };
}
