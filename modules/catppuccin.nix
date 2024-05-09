{ config, currentUser, ... }:
{
  config.catppuccin = config.home-manager.users.${currentUser}.catppuccin;
}
