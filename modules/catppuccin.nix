{ config, currentUser, ... }:
{
  config.catppuccin = {
    inherit (config.home-manager.users.${currentUser}.catppuccin) enable flavor accent;
  };
}
