{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
let
  cfg = config.homeModules.homeTheater;
  inherit (lib)
    concatMapAttrsStringSep
    escapeShellArg
    getExe
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  kodi = cfg.package.withPackages (p: [
    (p.callPackage inputs.playbackspeed-defaults.kodiAddons.default { })
  ]);
  kodi-bin = getExe kodi;

  xmlstarlet = getExe pkgs.xmlstarlet;
  guiSettingsFile = "${config.programs.kodi.datadir}/userdata/guisettings.xml";
  emptyGuiSettings = pkgs.writeText "guisettings.xml" ''
    <settings version="2" />
  '';
in
{
  options.homeModules.homeTheater = {
    enable = mkEnableOption "Home Theater with Kodi";
    package = mkOption {
      type = types.package;
      default = inputs.kodi-scaletempo2.packages.${system}.kodi-wayland;
      defaultText = lib.literalExpression "inputs.kodi-scaletempo2.packages.\${system}.kodi-wayland";
      description = ''
        The Kodi package to use, Kodi 22 from the scaletempo2 fork by default.
        Unwrapped, add-ons are added with its `withPackages`.
      '';
    };
    guiSettings = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        "videoplayer.usedisplayasclock" = "true";
      };
      description = ''
        Kodi GUI settings (guisettings.xml), forced on every activation.
        Kodi owns that file, so unlike advancedsettings.xml they stay
        editable in the GUI until the next activation.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.kodi = {
      enable = true;
      package = kodi;
      # The speed add-on's tempo up to 2.0x, on both Kodi 21 and 22
      settings.video.maxtempo = mkDefault "2.1";
    };

    # Kodi ignores speed changes without it
    homeModules.homeTheater.guiSettings."videoplayer.usedisplayasclock" = mkDefault "true";

    # Replace each setting's node so a `default="true"` attribute doesn't linger
    home.activation.kodiGuiSettings = mkIf (cfg.guiSettings != { }) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -e ${escapeShellArg guiSettingsFile} ]; then
          run install -Dm644 ${emptyGuiSettings} ${escapeShellArg guiSettingsFile}
        fi
        ${concatMapAttrsStringSep "\n" (id: value: ''
          run ${xmlstarlet} ed -L \
            -d ${escapeShellArg "/settings/setting[@id='${id}']"} \
            -s /settings -t elem -n setting -v ${escapeShellArg value} \
            -i '/settings/setting[last()]' -t attr -n id -v ${escapeShellArg id} \
            ${escapeShellArg guiSettingsFile}
        '') cfg.guiSettings}
      ''
    );

    programs.niri.settings = {
      hotkey-overlay.skip-at-startup = true;
      spawn-at-startup = [
        { argv = [ kodi-bin ]; }
      ];
    };
  };
}
