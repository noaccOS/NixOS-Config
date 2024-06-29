{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeModules.programs.shells.nu;
  inherit (lib)
    mkEnableOption
    mkIf
    optionalString
    pipe
    ;
in
{
  options.homeModules.programs.shells.nu = {
    enable = mkEnableOption "nushell";
  };
  config = mkIf cfg.enable {
    programs.nushell =
      # Nu's config depends on carapace to be enabled
      assert config.programs.carapace.enable;
      {
        enable = true;
        envFile.text = "";
        configFile.text = pipe ./config.nu [
          builtins.readFile
          (builtins.replaceStrings
            [
              "/usr/bin/env fish"
              "/usr/bin/env zoxide"
              "/usr/bin/env carapace"
            ]
            [
              "${config.programs.fish.package}/bin/fish"
              "${config.programs.zoxide.package}/bin/zoxide"
              "${config.programs.carapace.package}/bin/carapace"
            ]
          )
        ];
        extraConfig = ''
          source '${
            pkgs.runCommand "nix-your-shell-config.nu" { }
              "${pkgs.nix-your-shell}/bin/nix-your-shell nu >> $out"
          }'
        '';
      };
  };
}
