{ pkgs, config, lib, currentUser, ... }:
let cfg = config.noaccOSModules.development;
in {
  options.noaccOSModules.development = with lib; {
    enable = mkEnableOption "Dev tools, mostly languages and compilers";
  };

  config.home-manager.users.${currentUser}.homeModules.development.enableTools = cfg.enable;
}
