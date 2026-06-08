{
  config,
  user,
  ...
}:
{
  config.catppuccin = {
    inherit (config.home-manager.users.${user}.catppuccin) enable autoEnable flavor accent;
    cache.enable = true;
  };
}
