{
  config,
  inputs,
  lib,
  system,
  ...
}:
let
  cfg = config.homeModules.windowManagers.dms;

  inherit (lib)
    mkEnableOption
    mkIf
    ;

  dms-ipc = subcommand: action: [
    "dms"
    "ipc"
    "call"
    subcommand
    action
  ];

  dms-ipc3 =
    subcommand: action: value:
    (dms-ipc subcommand action) ++ [ value ];

  dms-ipc4 =
    subcommand: action: value: device:
    (dms-ipc3 subcommand action value) ++ [ device ];

  # https://github.com/AvengeMedia/DankMaterialShell/issues/2173
  dms = inputs.dms.packages.${system}.default.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      # Line 1 == Inactive width
      # Line 2 == Heigth
      substituteInPlace $out/share/quickshell/dms/Modules/DankBar/Widgets/WorkspaceSwitcher.qml \
        --replace 'Math.max(root.widgetHeight * 0.7, root.appIconSize * 1.2)' 'widgetHeight * 0.25' \
        --replace '(SettingsData.showWorkspaceApps ? Math.max(widgetHeight * 0.7, root.appIconSize + Theme.spacingXS * 2) : widgetHeight * 0.5)' '(isActive ? (SettingsData.showWorkspaceApps ? Math.max(widgetHeight * 0.7, root.appIconSize + Theme.spacingXS * 2) : widgetHeight * 0.37) : (SettingsData.showWorkspaceApps ? Math.max(widgetHeight * 0.7, root.appIconSize + Theme.spacingXS * 2) : widgetHeight * 0.25))'
    '';
  });
in
{
  options.homeModules.windowManagers.dms = {
    enable = mkEnableOption "dank material shell";
  };

  config = mkIf cfg.enable {

    programs.dank-material-shell = {
      enable = true;
      package = dms;
      niri = {
        enableSpawn = true;
        includes.enable = false;
      };
    };

    homeModules.windowManagers.niri = {
      application-launcher = dms-ipc "spotlight" "toggle";
      lockscreen = dms-ipc "lock" "lock";
      raise-volume = dms-ipc3 "audio" "increment" "3";
      lower-volume = dms-ipc3 "audio" "decrement" "3";
      mute = dms-ipc "audio" "mute";
      mute-mic = dms-ipc "audio" "micmute";
      media-play-pause = dms-ipc "mpris" "playPause";
      media-previous = dms-ipc "mpris" "previous";
      media-next = dms-ipc "mpris" "next";
      brightness-up = dms-ipc4 "brightness" "increment" "5" "";
      brightness-down = dms-ipc4 "brightness" "decrement" "5" "";
    };
  };
}
