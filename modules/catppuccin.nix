{ config, user, ... }:
{
  config.catppuccin = {
    inherit (config.home-manager.users.${user}.catppuccin) enable flavor accent;
  };
}
