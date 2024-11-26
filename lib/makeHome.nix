{
  nixpkgs,
  home-manager,
  emacs-overlay,
  catppuccin,
  nix-index-database,
  ...
}@inputs:
{
  system ? "x86_64-linux",
  user ? "noaccos",
}:
home-manager.lib.homeManagerConfiguration {
  pkgs = import nixpkgs { inherit system; };
  modules = [
    ../home/home.nix

    catppuccin.homeManagerModules.catppuccin
    nix-index-database.hmModules.nix-index

    {
      homeModules.cli.sourceNix = true;
    }
  ];

  extraSpecialArgs = {
    inherit user inputs system;
    monitors = { };
  };
}
