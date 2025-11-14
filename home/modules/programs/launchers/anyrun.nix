{
  config,
  lib,
  inputs,
  system,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    getExe
    types
    ;
  cfg = config.homeModules.programs.launchers.anyrun;

in
{
  options.homeModules.programs.launchers.anyrun = {
    enable = mkEnableOption "anyrun";

    daemon = mkEnableOption "running anyrun as daemon" // {
      default = true;
    };

    package = mkOption {
      type = types.package;
      default = inputs.anyrun.packages.${system}.default;
    };
  };

  config = mkIf cfg.enable {
    programs.anyrun = {
      enable = true;

      package = cfg.package;

      config = {
        plugins = with inputs.anyrun.packages.${system}; [
          applications
          kidex
          randr
          rink
          shell
          stdin
          symbols
          websearch
        ];
      };
    };

    systemd.user.services.anyrun = mkIf cfg.daemon {
      Unit = {
        Description = "Anyrun daemon";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
      };

      Service = {
        Type = "simple";
        ExecStart = "${getExe cfg.package} daemon";
        Restart = "on-failure";
        KillMode = "process";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
