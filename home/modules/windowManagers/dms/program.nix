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
      settings = {
        acLockTimeout = 0;
        acMonitorTimeout = 0;
        acProfileName = "";
        acSuspendBehavior = 0;
        acSuspendTimeout = 0;
        activeDisplayProfile = { };
        animationSpeed = 1;
        appDrawerSectionViewModes = { };
        appIdSubstitutions = [
          {
            pattern = "Spotify";
            replacement = "spotify";
            type = "exact";
          }
          {
            pattern = "beepertexts";
            replacement = "beeper";
            type = "exact";
          }
          {
            pattern = "home assistant desktop";
            replacement = "homeassistant-desktop";
            type = "exact";
          }
          {
            pattern = "com.transmissionbt.transmission";
            replacement = "transmission-gtk";
            type = "contains";
          }
          {
            pattern = "^steam_app_(\\d+)$";
            replacement = "steam_icon_$1";
            type = "regex";
          }
        ];
        appLauncherGridColumns = 4;
        appLauncherViewMode = "list";
        appPickerViewMode = "grid";
        appsDockActiveColorMode = "primary";
        appsDockColorizeActive = false;
        appsDockEnlargeOnHover = false;
        appsDockEnlargePercentage = 125;
        appsDockHideIndicators = false;
        appsDockIconSizePercentage = 100;
        audioInputDevicePins = { };
        audioOutputDevicePins = { };
        audioScrollMode = "volume";
        audioVisualizerEnabled = true;
        audioWheelScrollAmount = 5;
        barConfigs = [
          {
            autoHide = false;
            autoHideDelay = 250;
            borderColor = "surfaceText";
            borderEnabled = false;
            borderOpacity = 1;
            borderThickness = 1;
            bottomGap = 0;
            centerWidgets = [
              {
                enabled = true;
                id = "notificationButton";
              }
              {
                enabled = true;
                id = "clock";
              }
              {
                enabled = true;
                id = "music";
              }
            ];
            enabled = true;
            fontScale = 1;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            gothCornersEnabled = false;
            id = "default";
            innerPadding = 4;
            leftWidgets = [
              {
                enabled = true;
                id = "workspaceSwitcher";
              }
            ];
            maximizeWidgetIcons = false;
            maximizeWidgetText = false;
            name = "Main Bar";
            noBackground = false;
            openOnOverview = false;
            popupGapsAuto = true;
            popupGapsManual = 38;
            position = 0;
            removeWidgetPadding = false;
            rightWidgets = [
              {
                enabled = true;
                id = "clipboard";
              }
              {
                enabled = true;
                id = "controlCenterButton";
                showAudioIcon = true;
                showAudioPercent = false;
                showBatteryIcon = true;
                showBrightnessIcon = true;
                showMicIcon = false;
                showMicPercent = false;
              }
            ];
            screenPreferences = [ "all" ];
            showOnLastDisplay = true;
            spacing = 0;
            squareCorners = true;
            transparency = 1;
            visible = true;
            widgetOutlineEnabled = false;
            widgetPadding = 8;
            widgetTransparency = 1;
          }
        ];
        barMaxVisibleApps = 0;
        barMaxVisibleRunningApps = 0;
        barShowOverflowBadge = true;
        batteryChargeLimit = 100;
        batteryLockTimeout = 0;
        batteryMonitorTimeout = 0;
        batteryProfileName = "";
        batterySuspendBehavior = 0;
        batterySuspendTimeout = 0;
        bluetoothDevicePins = { };
        blurBorderColor = "outline";
        blurBorderCustomColor = "#ffffff";
        blurBorderOpacity = 0.35;
        blurEnabled = false;
        blurForegroundLayers = true;
        blurLayerOutlineOpacity = 0.12;
        blurWallpaperOnOverview = false;
        blurredWallpaperLayer = false;
        brightnessDevicePins = { };
        browserPickerViewMode = "grid";
        browserUsageHistory = { };
        builtInPluginSettings = {
          dms_settings_search = {
            trigger = "?";
          };
          dms_sysmon = {
            enabled = false;
          };
        };
        buttonColorMode = "primary";
        centeringMode = "index";
        clipboardEnterToPaste = false;
        clockCompactMode = false;
        clockDateFormat = "ddd、MMMdd日";
        configVersion = 5;
        controlCenterShowAudioIcon = true;
        controlCenterShowAudioPercent = false;
        controlCenterShowBatteryIcon = false;
        controlCenterShowBluetoothIcon = true;
        controlCenterShowBrightnessIcon = false;
        controlCenterShowBrightnessPercent = false;
        controlCenterShowMicIcon = false;
        controlCenterShowMicPercent = false;
        controlCenterShowNetworkIcon = true;
        controlCenterShowPrinterIcon = false;
        controlCenterShowScreenSharingIcon = true;
        controlCenterShowVpnIcon = true;
        controlCenterTileColorMode = "primary";
        controlCenterWidgets = [
          {
            enabled = true;
            id = "volumeSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "brightnessSlider";
            width = 50;
          }
          {
            enabled = true;
            id = "wifi";
            width = 50;
          }
          {
            enabled = true;
            id = "bluetooth";
            width = 50;
          }
          {
            enabled = true;
            id = "audioOutput";
            width = 50;
          }
          {
            enabled = true;
            id = "audioInput";
            width = 50;
          }
          {
            enabled = true;
            id = "nightMode";
            width = 50;
          }
          {
            enabled = true;
            id = "darkMode";
            width = 50;
          }
        ];
        cornerRadius = 12;
        currentThemeCategory = "registry";
        currentThemeName = "custom";
        customAnimationDuration = 500;
        customPowerActionHibernate = "";
        customPowerActionLock = "";
        customPowerActionLogout = "";
        customPowerActionPowerOff = "";
        customPowerActionReboot = "";
        customPowerActionSuspend = "";
        customThemeFile = ./catpuccin-theme.json;
        dankLauncherV2BorderColor = "primary";
        dankLauncherV2BorderEnabled = true;
        dankLauncherV2BorderThickness = 2;
        dankLauncherV2ShowFooter = true;
        dankLauncherV2Size = "medium";
        dankLauncherV2UnloadOnClose = false;
        desktopClockColorMode = "primary";
        desktopClockCustomColor = {
          a = 1;
          b = 1;
          g = 1;
          hslHue = -1;
          hslLightness = 1;
          hslSaturation = 0;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          r = 1;
          valid = true;
        };
        desktopClockDisplayPreferences = [ "all" ];
        desktopClockEnabled = false;
        desktopClockHeight = 180;
        desktopClockShowAnalogNumbers = false;
        desktopClockShowAnalogSeconds = true;
        desktopClockShowDate = true;
        desktopClockStyle = "analog";
        desktopClockTransparency = 0.8;
        desktopClockWidth = 280;
        desktopClockX = -1;
        desktopClockY = -1;
        desktopWidgetGridSettings = { };
        desktopWidgetGroups = [ ];
        desktopWidgetInstances = [ ];
        desktopWidgetPositions = { };
        displayNameMode = "system";
        displayProfileAutoSelect = false;
        displayProfiles = { };
        displayShowDisconnected = false;
        displaySnapToEdge = true;
        dockAutoHide = false;
        dockBorderColor = "surfaceText";
        dockBorderEnabled = true;
        dockBorderOpacity = 1;
        dockBorderThickness = 1;
        dockBottomGap = 0;
        dockGroupByApp = true;
        dockIconSize = 40;
        dockIndicatorStyle = "circle";
        dockIsolateDisplays = true;
        dockLauncherEnabled = true;
        dockLauncherLogoBrightness = 0.5;
        dockLauncherLogoColorOverride = "";
        dockLauncherLogoContrast = 1;
        dockLauncherLogoCustomPath = "";
        dockLauncherLogoMode = "os";
        dockLauncherLogoSizeOffset = 0;
        dockMargin = 0;
        dockMaxVisibleApps = 0;
        dockMaxVisibleRunningApps = 5;
        dockOpenOnOverview = false;
        dockPosition = 1;
        dockShowOverflowBadge = true;
        dockSmartAutoHide = true;
        dockSpacing = 8;
        dockTransparency = 1;
        dwlShowAllTags = false;
        enableFprint = false;
        enableRippleEffects = true;
        enableU2f = false;
        enabledGpuPciIds = [ ];
        fadeToDpmsEnabled = true;
        fadeToDpmsGracePeriod = 5;
        fadeToLockEnabled = true;
        fadeToLockGracePeriod = 5;
        filePickerUsageHistory = { };
        focusedWindowCompactMode = false;
        fontFamily = "Inter Nerd Font";
        fontScale = 1;
        fontWeight = 400;
        greeterEnableFprint = false;
        greeterEnableU2f = false;
        greeterRememberLastSession = true;
        greeterRememberLastUser = true;
        greeterWallpaperPath = "";
        groupWorkspaceApps = true;
        gtkThemingEnabled = false;
        hideBrightnessSlider = false;
        hyprlandLayoutBorderSize = -1;
        hyprlandLayoutGapsOverride = -1;
        hyprlandLayoutRadiusOverride = -1;
        hyprlandOutputSettings = { };
        iconTheme = "Adwaita";
        keyboardLayoutNameCompactMode = false;
        launchPrefix = "";
        launcherLogoBrightness = 0.5;
        launcherLogoColorInvertOnMode = false;
        launcherLogoColorOverride = "";
        launcherLogoContrast = 1;
        launcherLogoCustomPath = "";
        launcherLogoMode = "apps";
        launcherLogoSizeOffset = 0;
        launcherPluginOrder = [ ];
        launcherPluginVisibility = { };
        lockAtStartup = false;
        lockBeforeSuspend = false;
        lockDateFormat = "";
        lockScreenActiveMonitor = "all";
        lockScreenInactiveColor = "#000000";
        lockScreenNotificationMode = 2;
        lockScreenPowerOffMonitorsOnLock = false;
        lockScreenShowDate = true;
        lockScreenShowMediaPlayer = true;
        lockScreenShowPasswordField = true;
        lockScreenShowPowerActions = true;
        lockScreenShowProfileImage = true;
        lockScreenShowSystemIcons = true;
        lockScreenShowTime = true;
        loginctlLockIntegration = true;
        mangoLayoutBorderSize = -1;
        mangoLayoutGapsOverride = -1;
        mangoLayoutRadiusOverride = -1;
        matugenScheme = "scheme-tonal-spot";
        matugenTargetMonitor = "";
        matugenTemplateAlacritty = true;
        matugenTemplateDgop = true;
        matugenTemplateEmacs = true;
        matugenTemplateEquibop = true;
        matugenTemplateFirefox = true;
        matugenTemplateFoot = true;
        matugenTemplateGhostty = true;
        matugenTemplateGtk = true;
        matugenTemplateHyprland = true;
        matugenTemplateKcolorscheme = true;
        matugenTemplateKitty = true;
        matugenTemplateMangowc = true;
        matugenTemplateNeovim = false;
        matugenTemplateNiri = true;
        matugenTemplatePywalfox = true;
        matugenTemplateQt5ct = true;
        matugenTemplateQt6ct = true;
        matugenTemplateVesktop = true;
        matugenTemplateVscode = true;
        matugenTemplateWezterm = true;
        matugenTemplateZed = true;
        matugenTemplateZenBrowser = true;
        maxFprintTries = 15;
        maxWorkspaceIcons = 3;
        mediaSize = 1;
        modalAnimationSpeed = 1;
        modalCustomAnimationDuration = 150;
        modalDarkenBackground = true;
        monoFontFamily = "Nosevka";
        muxCustomCommand = "";
        muxSessionFilter = "";
        muxType = "zellij";
        muxUseCustomCommand = false;
        networkPreference = "wifi";
        nightModeEnabled = false;
        niriLayoutBorderSize = -1;
        niriLayoutGapsOverride = -1;
        niriLayoutRadiusOverride = -1;
        niriOutputSettings = { };
        niriOverviewOverlayEnabled = true;
        notepadFontFamily = "";
        notepadFontSize = 14;
        notepadLastCustomTransparency = 0.7;
        notepadShowLineNumbers = false;
        notepadTransparencyOverride = -1;
        notepadUseMonospace = true;
        notificationAnimationSpeed = 1;
        notificationCompactMode = true;
        notificationCustomAnimationDuration = 400;
        notificationHistoryEnabled = true;
        notificationHistoryMaxAgeDays = 7;
        notificationHistoryMaxCount = 50;
        notificationHistorySaveCritical = true;
        notificationHistorySaveLow = true;
        notificationHistorySaveNormal = true;
        notificationOverlayEnabled = false;
        notificationPopupPosition = -1;
        notificationPopupPrivacyMode = false;
        notificationPopupShadowEnabled = true;
        notificationRules = [ ];
        notificationTimeoutCritical = 0;
        notificationTimeoutLow = 5000;
        notificationTimeoutNormal = 5000;
        osdAlwaysShowValue = false;
        osdAudioOutputEnabled = true;
        osdBrightnessEnabled = true;
        osdCapsLockEnabled = true;
        osdIdleInhibitorEnabled = true;
        osdMediaPlaybackEnabled = false;
        osdMediaVolumeEnabled = true;
        osdMicMuteEnabled = true;
        osdPosition = 5;
        osdPowerProfileEnabled = false;
        osdVolumeEnabled = true;
        padHours12Hour = false;
        popoutAnimationSpeed = 1;
        popoutCustomAnimationDuration = 150;
        popupTransparency = 1;
        powerActionConfirm = true;
        powerActionHoldDuration = 0.5;
        powerMenuActions = [
          "reboot"
          "logout"
          "poweroff"
          "lock"
          "suspend"
          "restart"
        ];
        powerMenuDefaultAction = "logout";
        powerMenuGridLayout = false;
        privacyShowCameraIcon = false;
        privacyShowMicIcon = false;
        privacyShowScreenShareIcon = false;
        qtThemingEnabled = false;
        registryThemeVariants = {
          catppuccin = {
            dark = {
              accent = "lavender";
              flavor = "mocha";
            };
          };
        };
        reverseScrolling = false;
        runDmsMatugenTemplates = false;
        runUserMatugenTemplates = false;
        runningAppsCompactMode = true;
        runningAppsCurrentMonitor = false;
        runningAppsCurrentWorkspace = true;
        runningAppsGroupByApp = false;
        screenPreferences = {
          wallpaper = [ "all" ];
        };
        scrollTitleEnabled = true;
        selectedGpuIndex = 0;
        showBattery = true;
        showCapsLockIndicator = true;
        showClipboard = true;
        showClock = true;
        showControlCenterButton = true;
        showCpuTemp = true;
        showCpuUsage = true;
        showDock = true;
        showFocusedWindow = true;
        showGpuTemp = true;
        showLauncherButton = true;
        showMemUsage = true;
        showMusic = true;
        showNotificationButton = true;
        showOccupiedWorkspacesOnly = false;
        showOnLastDisplay = { };
        showPrivacyButton = true;
        showSeconds = false;
        showSystemTray = true;
        showWeather = true;
        showWorkspaceApps = false;
        showWorkspaceIndex = false;
        showWorkspaceName = false;
        showWorkspacePadding = false;
        showWorkspaceSwitcher = true;
        sortAppsAlphabetically = false;
        soundNewNotification = true;
        soundPluggedIn = true;
        soundVolumeChanged = true;
        soundsEnabled = true;
        spotlightCloseNiriOverview = true;
        spotlightModalViewMode = "list";
        spotlightSectionViewModes = {
          apps = "list";
        };
        syncComponentAnimationSpeeds = true;
        syncModeWithPortal = true;
        systemMonitorColorMode = "primary";
        systemMonitorCustomColor = {
          a = 1;
          b = 1;
          g = 1;
          hslHue = -1;
          hslLightness = 1;
          hslSaturation = 0;
          hsvHue = -1;
          hsvSaturation = 0;
          hsvValue = 1;
          r = 1;
          valid = true;
        };
        systemMonitorDisplayPreferences = [ "all" ];
        systemMonitorEnabled = false;
        systemMonitorGpuPciId = "";
        systemMonitorGraphInterval = 60;
        systemMonitorHeight = 480;
        systemMonitorLayoutMode = "auto";
        systemMonitorShowCpu = true;
        systemMonitorShowCpuGraph = true;
        systemMonitorShowCpuTemp = true;
        systemMonitorShowDisk = true;
        systemMonitorShowGpuTemp = false;
        systemMonitorShowHeader = true;
        systemMonitorShowMemory = true;
        systemMonitorShowMemoryGraph = true;
        systemMonitorShowNetwork = true;
        systemMonitorShowNetworkGraph = true;
        systemMonitorShowTopProcesses = false;
        systemMonitorTopProcessCount = 3;
        systemMonitorTopProcessSortBy = "cpu";
        systemMonitorTransparency = 0.8;
        systemMonitorVariants = [ ];
        systemMonitorWidth = 320;
        systemMonitorX = -1;
        systemMonitorY = -1;
        systemTrayIconTintMode = "secondary";
        systemTrayIconTintSaturation = 50;
        systemTrayIconTintStrength = 135;
        terminalsAlwaysDark = false;
        u2fMode = "or";
        updaterCustomCommand = "";
        updaterHideWidget = false;
        updaterTerminalAdditionalParams = "";
        updaterUseCustomCommand = false;
        use24HourClock = true;
        useAutoLocation = false;
        useFahrenheit = false;
        useSystemSoundTheme = false;
        wallpaperFillMode = "Fill";
        waveProgressEnabled = true;
        weatherEnabled = false;
        widgetBackgroundColor = "sch";
        widgetColorMode = "colorful";
        wifiNetworkPins = { };
        windSpeedUnit = "kmh";
        workspaceAppIconSizeOffset = 0;
        workspaceColorMode = "default";
        workspaceDragReorder = true;
        workspaceFocusedBorderColor = "primary";
        workspaceFocusedBorderEnabled = false;
        workspaceFocusedBorderThickness = 2;
        workspaceFollowFocus = false;
        workspaceNameIcons = { };
        workspaceOccupiedColorMode = "none";
        workspaceScrolling = false;
        workspaceUnfocusedColorMode = "default";
        workspaceUrgentColorMode = "default";
      };
      session = {
        wallpaperPath = ../../../../assets/wallpaper.jpg;
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
