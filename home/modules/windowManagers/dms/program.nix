{
  config,
  lib,
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
in
{
  options.homeModules.windowManagers.dms = {
    enable = mkEnableOption "dank material shell";
  };

  config = mkIf cfg.enable {

    programs.dank-material-shell = {
      enable = true;
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
        appPickerViewMode = "grid";
        audioVisualizerEnabled = true;
        audioWheelScrollAmount = 5;
        barConfigs = [
          {
            attachToScreenEdge = false;
            autoHide = false;
            autoHideDelay = 250;
            borderColor = "surfaceText";
            borderEnabled = false;
            borderOpacity = 1;
            borderThickness = 1;
            bottomGap = 0;
            centerWidgets = [
              {
                clockCompactMode = false;
                enabled = true;
                id = "clock";
              }
            ];
            dot = false;
            enabled = true;
            followInterfaceStyle = true;
            fontScale = 1;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            gothCornersEnabled = false;
            id = "default";
            innerPadding = 4;
            island = false;
            leftWidgets = [
              {
                dwlShowAllTags = false;
                enabled = true;
                groupWorkspaceApps = true;
                id = "workspaceSwitcher";
                maxWorkspaceIcons = 3;
                reverseScrolling = false;
                showOccupiedWorkspacesOnly = false;
                showWorkspaceApps = false;
                showWorkspaceIndex = false;
                showWorkspaceName = false;
                showWorkspacePadding = false;
                workspaceAppIconSizeOffset = 0;
                workspaceColorMode = "default";
                workspaceDragReorder = true;
                workspaceFocusedBorderColor = "primary";
                workspaceFocusedBorderEnabled = false;
                workspaceFocusedBorderThickness = 2;
                workspaceFollowFocus = false;
                workspaceIndicatorCompact = true;
                workspaceIndicatorRoundness = -1;
                workspaceIndicatorStyle = "lines";
                workspaceOccupiedColorMode = "none";
                workspaceUnfocusedColorMode = "default";
                workspaceUrgentColorMode = "default";
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
                showBluetoothIcon = true;
                showBrightnessIcon = true;
                showBrightnessPercent = false;
                showDoNotDisturbIcon = true;
                showMicIcon = false;
                showMicPercent = false;
                showNetworkIcon = true;
                showPrinterIcon = false;
                showScreenSharingIcon = true;
                showVpnIcon = true;
              }
            ];
            screenPreferences = [ "all" ];
            shadowIntensity = 0;
            showOnLastDisplay = true;
            spacing = 0;
            squareCorners = true;
            transparency = 1;
            visible = true;
            widgetFollowInterfaceStyle = true;
            widgetOutlineEnabled = false;
            widgetPadding = 8;
            widgetTransparency = 1;
          }
        ];
        barElevationEnabled = false;
        batteryChargeLimit = 100;
        batteryLockTimeout = 0;
        batteryMonitorTimeout = 0;
        batteryProfileName = "";
        batterySuspendBehavior = 0;
        batterySuspendTimeout = 0;
        blurBorderColor = "outline";
        blurBorderCustomColor = "#ffffff";
        blurBorderEnabled = false;
        blurBorderOpacity = 0.35;
        blurEnabled = false;
        blurForegroundLayers = true;
        blurLayerOutlineOpacity = 0.12;
        blurWallpaperOnOverview = false;
        blurredWallpaperLayer = false;
        browserPickerViewMode = "grid";
        builtInPluginSettings = {
          dms_clipboard_search = {
            trigger = "cb";
          };
          dms_power = {
            trigger = "pw";
          };
          dms_qr_generator = {
            trigger = "qrg";
          };
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
        clockDateFormat = "ddd、MMMdd日";
        clockFormat = "24h";
        configVersion = 42;
        connectedFrameBarStyleBackups = { };
        controlCenterTileColorMode = "primary";
        controlCenterWidgets = [
          {
            enabled = true;
            h = 1;
            id = "user";
            w = 5;
          }
          {
            enabled = true;
            h = 1;
            id = "settings";
            small = true;
            w = 1;
          }
          {
            enabled = true;
            h = 1;
            id = "lock";
            small = true;
            w = 1;
          }
          {
            enabled = true;
            h = 1;
            id = "power";
            small = true;
            w = 1;
          }
          {
            enabled = true;
            h = 1;
            id = "volumeSlider";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "brightnessSlider";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "wifi";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "bluetooth";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "audioOutput";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "audioInput";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "nightMode";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "darkMode";
            w = 4;
          }
          {
            enabled = true;
            h = 1;
            id = "edit";
            small = true;
            w = 1;
          }
          {
            col = 0;
            enabled = true;
            h = 1;
            id = "runningApps";
            row = 6;
            small = true;
            w = 4;
          }
        ];
        currentThemeCategory = "registry";
        currentThemeName = "custom";
        customPowerActionHibernate = "";
        customPowerActionLock = "";
        customPowerActionLogout = "";
        customPowerActionPowerOff = "";
        customPowerActionReboot = "";
        customPowerActionSuspend = "";
        customThemeFile = "/nix/store/wjkgk913g74gl5574wqyqm7krrzsp7yz-catpuccin-theme.json";
        dankLauncherV2BorderColor = "primary";
        dankLauncherV2BorderEnabled = true;
        dankLauncherV2BorderThickness = 2;
        dankLauncherV2IncludeFilesInAll = true;
        dankLauncherV2IncludeFoldersInAll = true;
        dankLauncherV2ShowFooter = true;
        dankLauncherV2Size = "medium";
        dankLauncherV2UnloadOnClose = false;
        desktopWidgetGroups = [ ];
        desktopWidgetInstances = [ ];
        displayNameMode = "system";
        displayProfileAutoSelect = false;
        displayProfiles = { };
        displayShowDisconnected = false;
        displaySnapToEdge = true;
        dmsWindowsFloatingSeeded = [ "niri" ];
        dockConfigs = [
          {
            autoHide = false;
            borderColor = "surfaceText";
            borderEnabled = true;
            borderOpacity = 1;
            borderThickness = 1;
            bottomGap = 0;
            editOnRightClick = false;
            enabled = true;
            followInterfaceStyle = true;
            groupByApp = true;
            iconSize = 40;
            id = "dock";
            indicatorStyle = "circle";
            isolateDisplays = true;
            itemSpacing = 4;
            launcherEnabled = true;
            launcherLogoBrightness = 0.5;
            launcherLogoColorOverride = "";
            launcherLogoContrast = 1;
            launcherLogoCustomPath = "";
            launcherLogoMode = "os";
            launcherLogoSizeOffset = 0;
            magnification = false;
            magnificationExpand = false;
            magnificationProfile = "parabolic";
            magnificationScale = 130;
            margin = 0;
            maxVisibleApps = 0;
            maxVisibleRunningApps = 5;
            mode = "compact";
            name = "Dock";
            openOnOverview = false;
            order = [ ];
            position = 1;
            restoreSpecialWorkspaceOnClick = false;
            screenPreferences = [ "all" ];
            separatePinnedAndRunningApps = false;
            showOnFullscreen = false;
            showOnLastDisplay = true;
            showOverflowBadge = true;
            showTrash = false;
            smartAutoHide = true;
            spacing = 8;
            taskbarAlign = "center";
            transparency = 1;
            trashCustomCommand = "";
            trashFileManager = "default";
            useOverlayLayer = false;
            widgetExpansion = "popout";
            widgets = [
              {
                enabled = true;
                id = "dock_launcher";
                widgetId = "dockLauncher";
              }
              {
                enabled = true;
                id = "dock_apps";
                widgetId = "appsDock";
              }
              {
                enabled = true;
                id = "dock_trash";
                widgetId = "dockTrash";
              }
            ];
          }
        ];
        enableFprint = false;
        enableRippleEffects = true;
        enableU2f = false;
        fadeToDpmsEnabled = true;
        fadeToDpmsGracePeriod = 5;
        fadeToLockEnabled = true;
        fadeToLockGracePeriod = 5;
        firstDayOfWeek = 1;
        fontFamily = "Inter Nerd Font";
        fontScale = 1;
        fontWeight = 400;
        frameEnabled = false;
        greeterEnableFprint = false;
        greeterEnableU2f = false;
        greeterRememberLastSession = true;
        greeterRememberLastUser = true;
        greeterWidgetInstances = [
          {
            config = {
              autoPosition = true;
              colorMode = "default";
              customColor = "#ffffff";
              displayPreferences = [ "all" ];
              showAnalogNumbers = false;
              showAnalogSeconds = true;
              showDate = false;
              showDigitalSeconds = false;
              style = "expressive";
              syncPositionAcrossScreens = true;
              transparency = 0;
              twoTone = true;
              weight = 0;
            };
            enabled = true;
            id = "lock_clock";
            widgetType = "desktopClock";
          }
          {
            config = {
              colorMode = "default";
              customColor = "#ffffff";
              displayPreferences = [ "all" ];
              format = "short";
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "lock_date";
            widgetType = "lockDate";
          }
          {
            config = {
              displayPreferences = [ "all" ];
              passwordVisibility = "always";
              profileVisibility = "always";
              style = "expressive";
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "lock_auth";
            widgetType = "lockAuth";
          }
          {
            config = {
              background = false;
              displayPreferences = [ "all" ];
              showMediaPlayer = true;
              showWeather = true;
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "lock_status";
            widgetType = "lockStatus";
          }
          {
            config = {
              displayPreferences = [ "all" ];
              shape = "round";
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "lock_power";
            widgetType = "lockPower";
          }
          {
            config = {
              displayPreferences = [ "all" ];
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "greeter_session";
            widgetType = "greeterSession";
          }
        ];
        hyprlandLayoutBorderSize = -1;
        hyprlandLayoutGapsOverride = -1;
        hyprlandLayoutRadiusOverride = -1;
        iconThemeDark = "Adwaita";
        launchPrefix = "";
        launcherPluginOrder = [ ];
        launcherPluginVisibility = { };
        launcherStyle = "spotlight";
        lockAtStartup = false;
        lockBeforeSuspend = false;
        lockDateFormat = "";
        lockScreenFontFamily = "Inter Nerd Font";
        lockScreenInactiveColor = "#000000";
        lockScreenPowerOffMonitorsOnLock = false;
        lockScreenShowPowerActions = true;
        lockScreenShowProfileImage = true;
        lockScreenWidgetInstances = [
          {
            config = {
              autoPosition = true;
              colorMode = "default";
              customColor = "#ffffff";
              displayPreferences = [ "all" ];
              showAnalogNumbers = false;
              showAnalogSeconds = true;
              showDate = false;
              showDigitalSeconds = false;
              style = "expressive";
              syncPositionAcrossScreens = true;
              transparency = 0;
              twoTone = true;
              weight = 0;
            };
            enabled = true;
            id = "lock_clock";
            widgetType = "desktopClock";
          }
          {
            config = {
              colorMode = "default";
              customColor = "#ffffff";
              displayPreferences = [ "all" ];
              format = "short";
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "lock_date";
            widgetType = "lockDate";
          }
          {
            config = {
              displayPreferences = [ "all" ];
              passwordVisibility = "always";
              profileVisibility = "always";
              style = "expressive";
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "lock_auth";
            widgetType = "lockAuth";
          }
          {
            config = {
              displayPreferences = [ "all" ];
              mode = 2;
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "lock_notifications";
            widgetType = "lockNotifications";
          }
          {
            config = {
              background = false;
              displayPreferences = [ "all" ];
              showMediaPlayer = true;
              showWeather = true;
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "lock_status";
            widgetType = "lockStatus";
          }
          {
            config = {
              displayPreferences = [ "all" ];
              shape = "round";
              syncPositionAcrossScreens = true;
            };
            enabled = true;
            id = "lock_power";
            widgetType = "lockPower";
          }
        ];
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
        modalDarkenBackground = true;
        monoFontFamily = "Nosevka";
        muxCustomCommand = "";
        muxSessionFilter = "";
        muxType = "zellij";
        muxUseCustomCommand = false;
        networkPreference = "wifi";
        niriLayoutBorderSize = -1;
        niriLayoutGapsOverride = -1;
        niriLayoutRadiusOverride = -1;
        niriOverviewLauncherStyle = "spotlight";
        niriOverviewOverlayEnabled = true;
        notepadFontFamily = "";
        notepadFontSize = 14;
        notepadLastCustomTransparency = 0.7;
        notepadShowLineNumbers = false;
        notepadTransparencyOverride = -1;
        notepadUseMonospace = true;
        notificationCompactMode = true;
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
        radiusMode = "scale";
        radiusStrength = 38;
        registryThemeVariants = {
          catppuccin = {
            dark = {
              accent = "lavender";
              flavor = "mocha";
            };
          };
        };
        runDmsMatugenTemplates = false;
        runUserMatugenTemplates = false;
        screenPreferences = {
          wallpaper = [ "all" ];
        };
        scrollTitleEnabled = true;
        showOnLastDisplay = { };
        showSeconds = false;
        sortAppsAlphabetically = false;
        soundNewNotification = true;
        soundPluggedIn = true;
        soundVolumeChanged = true;
        soundsEnabled = true;
        spotlightSectionViewModes = {
          apps = "list";
        };
        springBounce = 0;
        syncComponentAnimationSpeeds = true;
        syncModeWithPortal = true;
        systemTrayIconTintMode = "secondary";
        systemTrayIconTintSaturation = 50;
        systemTrayIconTintStrength = 135;
        terminalsAlwaysDark = false;
        textRenderQuality = 4;
        textRenderType = 1;
        u2fMode = "or";
        updaterCustomCommand = "";
        updaterTerminalAdditionalParams = "";
        updaterUseCustomCommand = false;
        useAutoLocation = false;
        useFahrenheit = false;
        useSystemSoundTheme = false;
        wallpaperFillMode = "Fill";
        weatherEnabled = false;
        widgetBackgroundColor = "sch";
        widgetColorMode = "colorful";
        windSpeedUnit = "kmh";
        workspaceNameIcons = { };
      };
      session = {
        wallpaperPath = ../../../../assets/wallpaper.jpg;
        pinnedApps = [
          "librewolf"
          "com.mitchellh.ghostty"
          "org.gnome.Nautilus"
        ];
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
