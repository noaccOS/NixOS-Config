{
  nixpkgs,
  nixpkgs-small,
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
    ./lix.nix
    ../home/home.nix

    catppuccin.homeModules.catppuccin
    nix-index-database.hmModules.nix-index

    {
      homeModules.cli.sourceNix = true;
    }
  ];

  extraSpecialArgs = {
    inherit user inputs system;
    pkgsSmall = import nixpkgs-small { inherit system; };
    monitors = { };
  };
}
