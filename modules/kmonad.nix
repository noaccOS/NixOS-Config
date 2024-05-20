{
  lib,
  currentUser,
  config,
  # inputs,
  ...
}:
let
  cfg = config.noaccOSModules.kmonad;
in
{
  options.noaccOSModules.kmonad = {
    enable = lib.mkEnableOption "KMonad utilities";
  };

  config = lib.mkIf cfg.enable {
    services.kmonad.enable = true;
    users.users.${currentUser}.extraGroups = [
      "input"
      "uinput" # Created by kmonad nixos-module
    ];
  };
}
