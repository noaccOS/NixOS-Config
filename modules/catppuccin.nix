{
  config,
  currentSystem,
  inputs,
  pkgs,
  user,
  ...
}:
{
  config.catppuccin = {
    inherit (config.home-manager.users.${user}.catppuccin) enable flavor accent;
    sources = inputs.catppuccin.packages.${currentSystem}.overrideScope (
      final: prev: {
        whiskers = pkgs.catppuccin-whiskers;
      }
    );

  };
}
