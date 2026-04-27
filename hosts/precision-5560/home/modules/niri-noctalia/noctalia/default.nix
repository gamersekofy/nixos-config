{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
    ./themes.nix
    ./wallpaper-picker.nix
  ];

  home.packages = [
    pkgs.gradia
  ];

  programs.noctalia-shell = {
    enable = true;

    plugins = {
      version = "2";
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        timer.enabled = true;
        pomodoro.enabled = true;
        kde-connect.enabled = true;
        polkit-agent.enabled = true;
        kaomoji-provider.enabled = true;
        screen-recorder.enabled = true;
        mawaqit.enabled = true;
        privacy-indicator.enabled = true;
      };
    };

    pluginSettings = {
      timer = {
        defaultDuration = 0;
        compactMode = false;
        iconColor = "primary";
        textColor = "primary";
      };

      kde-connect = {
        hideIfNoDeviceConnected = true;
      };

      screen-recorder = {
        hideInactive = false;
        iconColor = "none";
        directory = "/home/uzair/Videos/Screencasts";
        filenamePattern = "Video_yyyyMMdd_HHmmss";
        frameRate = "60";
        audioCodec = "opus";
        videoCodec = "h264";
        quality = "very_high";
        colorRange = "limited";
        showCursor = true;
        copyToClipboard = false;
        audioSource = "default_output";
        videoSource = "portal";
        resolution = "original";
        replayEnabled = false;
        replayDuration = "30";
        customReplayDuration = "30";
        replayStorage = "ram";
        restorePortalSession = false;
        customFrameRate = "60";
      };

      mawaqit = {
        city = "Redwood City";
        country = "US";
        method = 2;
        school = 0;
        showCountdown = true;
        showElapsed = false;
        hidePrayerName = false;
        showNotifications = true;
        playAzan = false;
        azanFile = "azan1.mp3";
        hijriDayOffset = 0;
        tune = false;
        tuneFajr = 0;
        tuneDhuhr = 0;
        tuneAsr = 0;
        tuneMaghrib = 0;
        tuneIsha = 0;
        widgetIcon = "building-mosque";
        dynamicIcon = false;
        textColor = "none";
        iconColor = "none";
        activeColor = "primary";
        weekStartDay = 0;
        fajrAngle = null;
        ishaAngle = null;
      };

      privacy-indicator = {
        hideInactive = true;
        enableToast = true;
        removeMargins = false;
        iconSpacing = 4;
        activeColor = "primary";
        inactiveColor = "none";
        micFilterRegex = "effect_input.rnnoise|easyeffects";
        camFilterRegex = "";
      };
    };

    settings = {
      settingsVersion = 59;

      bar = {
        barType = "simple";
        position = "left";
        monitors = [];
        density = "comfortable";
        showOutline = false;
        showCapsule = true;
        capsuleOpacity = 1;
        capsuleColorKey = "none";
        widgetSpacing = 6;
        contentPadding = 2;
        fontScale = 1.2000000000000002;
        enableExclusionZoneInset = true;
        backgroundOpacity = 0.93;
        useSeparateOpacity = false;
        marginVertical = 4;
        marginHorizontal = 4;
        frameThickness = 8;
        frameRadius = 12;
        outerCorners = true;
        hideOnOverview = false;
        displayMode = "always_visible";
        autoHideDelay = 500;
        autoShowDelay = 150;
        showOnWorkspaceSwitch = true;
        widgets = {
          left = [
            {
              id = "Clock";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - ddd MMM dd";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
              customFont = "";
              clockColor = "none";
            }
            {
              id = "SystemMonitor";
              compactMode = false;
              diskPath = "/";
              iconColor = "none";
              showCpuCores = false;
              showCpuFreq = false;
              showCpuTemp = false;
              showCpuUsage = true;
              showDiskAvailable = true;
              showDiskUsage = false;
              showDiskUsageAsPercent = false;
              showGpuTemp = false;
              showLoadAverage = false;
              showMemoryAsPercent = false;
              showMemoryUsage = true;
              showNetworkStats = true;
              showSwapUsage = false;
              textColor = "none";
              useMonospaceFont = true;
              usePadding = false;
            }
            {
              id = "ActiveWindow";
              colorizeIcons = false;
              hideMode = "hidden";
              maxWidth = 200;
              scrollingMode = "hover";
              showIcon = true;
              showText = true;
              textColor = "none";
              useFixedWidth = false;
            }
          ];
          center = [
            {
              id = "Workspace";
              characterCount = 2;
              colorizeIcons = false;
              emptyColor = "secondary";
              enableScrollWheel = true;
              focusedColor = "primary";
              followFocusedScreen = false;
              fontWeight = "bold";
              groupedBorderOpacity = 1;
              hideUnoccupied = true;
              iconScale = 0.8;
              labelMode = "index";
              occupiedColor = "secondary";
              pillSize = 0.6;
              showApplications = false;
              showApplicationsHover = false;
              showBadge = true;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
          ];
          right = [
            {
              id = "MediaMini";
              compactMode = false;
              hideMode = "hidden";
              hideWhenIdle = false;
              maxWidth = 145;
              panelShowAlbumArt = true;
              scrollingMode = "hover";
              showAlbumArt = true;
              showArtistFirst = false;
              showProgressRing = true;
              showVisualizer = true;
              textColor = "none";
              useFixedWidth = false;
              visualizerType = "mirrored";
            }
            {
              id = "Tray";
              blacklist = [];
              chevronColor = "none";
              colorizeIcons = false;
              drawerEnabled = false;
              hidePassive = true;
              pinned = [];
            }
            {
              id = "plugin:pomodoro";
            }
            {
              id = "plugin:mawaqit";
            }
            {
              id = "plugin:privacy-indicator";
            }
            {
              id = "NotificationHistory";
              hideWhenZero = false;
              hideWhenZeroUnread = false;
              iconColor = "none";
              showUnreadBadge = true;
              unreadBadgeColor = "primary";
            }
            {
              id = "plugin:kde-connect";
            }
            {
              id = "Battery";
              deviceNativePath = "__default__";
              displayMode = "icon-always";
              hideIfIdle = false;
              hideIfNotDetected = false;
              showNoctaliaPerformance = true;
              showPowerProfiles = true;
            }
            {
              id = "Network";
              iconColor = "none";
              textColor = "none";
              displayMode = "alwaysShow";
            }
            {
              id = "Volume";
              displayMode = "alwaysShow";
              iconColor = "none";
              middleClickCommand = "pwvucontrol || pavucontrol";
              textColor = "none";
            }
            {
              id = "Brightness";
              applyToAllMonitors = false;
              displayMode = "alwaysShow";
              iconColor = "none";
              textColor = "none";
            }
            {
              id = "ControlCenter";
              enableColorization = true;
              icon = "noctalia";
              useDistroLogo = false;
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              colorizeSystemText = "none";
              customIconPath = "";
            }
          ];
        };
        mouseWheelAction = "none";
        reverseScroll = false;
        mouseWheelWrap = true;
        middleClickAction = "none";
        middleClickFollowMouse = false;
        middleClickCommand = "";
        rightClickAction = "controlCenter";
        rightClickFollowMouse = true;
        rightClickCommand = "";
        screenOverrides = [];
      };

      general = {
        avatarImage = "/home/uzair/Pictures/kachina.png";
        dimmerOpacity = 0.2;
        showScreenCorners = false;
        forceBlackScreenCorners = false;
        scaleRatio = 1;
        radiusRatio = 1;
        iRadiusRatio = 1;
        boxRadiusRatio = 1;
        screenRadiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = false;
        compactLockScreen = false;
        lockScreenAnimations = true;
        lockOnSuspend = true;
        showSessionButtonsOnLockScreen = true;
        showHibernateOnLockScreen = true;
        enableLockScreenMediaControls = true;
        enableShadows = false;
        enableBlurBehind = false;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        language = "";
        allowPanelsOnScreenWithoutBar = true;
        showChangelogOnStartup = true;
        telemetryEnabled = false;
        enableLockScreenCountdown = true;
        lockScreenCountdownDuration = 10000;
        autoStartAuth = true;
        allowPasswordWithFprintd = true;
        clockStyle = "custom";
        clockFormat = "hh\nmm";
        passwordChars = true;
        lockScreenMonitors = [];
        lockScreenBlur = 0;
        lockScreenTint = 0;
        keybinds = {
          keyUp = ["Up"];
          keyDown = ["Down"];
          keyLeft = ["Left"];
          keyRight = ["Right"];
          keyEnter = ["Return" "Enter"];
          keyEscape = ["Esc"];
          keyRemove = ["Del"];
        };
        reverseScroll = false;
        smoothScrollEnabled = true;
      };

      ui = {
        fontDefault = "CaskaydiaCove Nerd Font";
        fontFixed = "CaskaydiaCove Nerd Font";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        scrollbarAlwaysVisible = false;
        boxBorderEnabled = false;
        panelBackgroundOpacity = 0.93;
        translucentWidgets = false;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        settingsPanelSideBarCardStyle = false;
      };

      location = {
        weatherEnabled = true;
        weatherShowEffects = true;
        weatherTaliaMascotAlways = false;
        useFahrenheit = true;
        use12hourFormat = false;
        showWeekNumberInCalendar = true;
        showCalendarEvents = true;
        showCalendarWeather = true;
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
        hideWeatherTimezone = false;
        hideWeatherCityName = false;
        autoLocate = true;
      };

      calendar = {
        cards = [
          {
            enabled = true;
            id = "calendar-header-card";
          }
          {
            enabled = true;
            id = "calendar-month-card";
          }
        ];
      };

      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        directory = "/home/uzair/Pictures/wallpapers";
        monitorDirectories = [];
        enableMultiMonitorDirectories = false;
        showHiddenFiles = false;
        viewMode = "recursive";
        setWallpaperOnAllMonitors = true;
        linkLightAndDarkWallpapers = true;
        fillMode = "crop";
        fillColor = "#000000";
        useSolidColor = false;
        solidColor = "#1a1a2e";
        automationEnabled = false;
        wallpaperChangeMode = "random";
        randomIntervalSec = 300;
        transitionDuration = 500;
        transitionType = [];
        skipStartupTransition = true;
        transitionEdgeSmoothness = 0;
        panelPosition = "follow_bar";
        hideWallpaperFilenames = false;
        useOriginalImages = false;
        overviewBlur = 1.0;
        overviewTint = 0.6;
        useWallhaven = false;
        wallhavenQuery = "";
        wallhavenSorting = "relevance";
        wallhavenOrder = "desc";
        wallhavenCategories = "111";
        wallhavenPurity = "100";
        wallhavenRatios = "";
        wallhavenApiKey = "";
        wallhavenResolutionMode = "atleast";
        wallhavenResolutionWidth = "";
        wallhavenResolutionHeight = "";
        sortOrder = "name";
        favorites = [];
      };

      appLauncher = {
        enableClipboardHistory = true;
        autoPasteClipboard = false;
        enableClipPreview = true;
        clipboardWrapText = true;
        enableClipboardSmartIcons = true;
        enableClipboardChips = true;
        lipboardWatchTextCommand = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
        clipboardWatchImageCommand = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
        position = "center";
        pinnedApps = [];
        sortByMostUsed = true;
        terminalCommand = "${pkgs.ghostty}/bin/ghostty -e";
        customLaunchPrefixEnabled = false;
        customLaunchPrefix = "";
        viewMode = "list";
        showCategories = true;
        iconMode = "tabler";
        showIconBackground = false;
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        enableSessionSearch = true;
        ignoreMouseInput = false;
        screenshotAnnotationTool = "${pkgs.gradia}/bin/gradia";
        overviewLayer = false;
        density = "default";
      };

      controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
          left = [
            {id = "Network";}
            {id = "Bluetooth";}
            {id = "AirplaneMode";}
            {id = "WallpaperSelector";}
          ];
          right = [
            {id = "DarkMode";}
            {id = "KeepAwake";}
            {id = "NightLight";}
            {
              defaultSettings = {
                compactMode = false;
                defaultDuration = 0;
                iconColor = "none";
                textColor = "none";
              };
              id = "plugin:timer";
            }
            {
              defaultSettings = {
                audioCodec = "opus";
                audioSource = "default_output";
                colorRange = "limited";
                copyToClipboard = false;
                customReplayDuration = "30";
                directory = "";
                filenamePattern = "Video_yyyyMMdd_HHmmss";
                frameRate = "60";
                hideInactive = false;
                iconColor = "none";
                quality = "very_high";
                replayDuration = "30";
                replayEnabled = false;
                replayStorage = "ram";
                resolution = "original";
                restorePortalSession = false;
                showCursor = true;
                videoCodec = "h264";
                videoSource = "portal";
              };
              id = "plugin:screen-recorder";
            }
          ];
        };
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = false;
            id = "brightness-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };

      systemMonitor = {
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        gpuCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        swapWarningThreshold = 80;
        swapCriticalThreshold = 90;
        diskWarningThreshold = 80;
        diskCriticalThreshold = 90;
        diskAvailWarningThreshold = 20;
        diskAvailCriticalThreshold = 10;
        batteryWarningThreshold = 30;
        batteryCriticalThreshold = 15;
        enableDgpuMonitoring = false;
        useCustomColors = false;
        warningColor = "";
        criticalColor = "";
        externalMonitor = "${pkgs.mission-center}/bin/missioncenter";
      };

      noctaliaPerformance = {
        disableWallpaper = true;
        disableDesktopWidgets = true;
      };

      dock = {
        enabled = false;
        position = "left";
        displayMode = "auto_hide";
        dockType = "floating";
        backgroundOpacity = 1;
        floatingRatio = 1;
        size = 1;
        onlySameOutput = true;
        monitors = [];
        pinnedApps = [
          "org.gnome.Nautilus"
          "firefox"
          "spotify"
          "com.yubico.yubioath"
          "org.keepassxc.KeePassXC"
          "com.mitchellh.ghostty"
          "qalculate-gtk"
        ];
        colorizeIcons = false;
        showLauncherIcon = true;
        launcherPosition = "start";
        launcherUseDistroLogo = true;
        launcherIcon = "";
        launcherIconColor = "none";
        pinnedStatic = false;
        inactiveIndicators = true;
        groupApps = false;
        groupContextMenuMode = "extended";
        groupClickAction = "cycle";
        groupIndicatorStyle = "dots";
        deadOpacity = 0.6;
        animationSpeed = 1;
        sitOnFrame = false;
        showDockIndicator = true;
        indicatorThickness = 3;
        indicatorColor = "primary";
        indicatorOpacity = 0.6;
      };

      network = {
        bluetoothRssiPollingEnabled = false;
        bluetoothRssiPollIntervalMs = 60000;
        networkPanelView = "wifi";
        wifiDetailsViewMode = "grid";
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        disableDiscoverability = false;
        bluetoothAutoConnect = true;
      };

      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 10000;
        position = "center";
        showHeader = true;
        showKeybinds = true;
        largeButtonsStyle = true;
        largeButtonsLayout = "single-row";
        powerOptions = [
          {
            action = "lock";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "1";
          }
          {
            action = "suspend";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "2";
          }
          {
            action = "hibernate";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "3";
          }
          {
            action = "reboot";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "4";
          }
          {
            action = "logout";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "5";
          }
          {
            action = "shutdown";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "6";
          }
          {
            action = "rebootToUefi";
            command = "";
            countdownEnabled = true;
            enabled = true;
            keybind = "7";
          }
          {
            action = "userspaceReboot";
            command = "";
            countdownEnabled = true;
            enabled = false;
            keybind = "";
          }
        ];
      };

      notifications = {
        enabled = true;
        enableMarkdown = false;
        density = "default";
        monitors = [];
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 1;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
        clearDismissed = true;
        saveToHistory = {
          low = true;
          normal = true;
          critical = true;
        };
        sounds = {
          enabled = false;
          volume = 0.5;
          separateSounds = false;
          criticalSoundFile = "";
          normalSoundFile = "";
          lowSoundFile = "";
          excludedApps = "discord,firefox,chrome,chromium,edge";
        };
        enableMediaToast = false;
        enableKeyboardLayoutToast = true;
        enableBatteryToast = true;
      };

      osd = {
        enabled = true;
        location = "bottom_left";
        autoHideMs = 2000;
        overlayLayer = true;
        backgroundOpacity = 1;
        enabledTypes = [0 1 2];
        monitors = [];
      };

      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        spectrumFrameRate = 30;
        visualizerType = "linear";
        spectrumMirrored = true;
        mprisBlacklist = [];
        preferredPlayer = "";
        volumeFeedback = false;
        volumeFeedbackSoundFile = "";
      };

      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = false;
        backlightDeviceMappings = [];
      };

      colorSchemes = {
        useWallpaperColors = true;
        predefinedScheme = "Noctalia (default)";
        schedulingMode = "location";
        manualSunrise = "06:30";
        manualSunset = "18:30";
        generationMethod = "tonal-spot";
        monitorForColors = "";
        syncGsettings = true;
      };

      templates = {
        activeTemplates = [
          {
            enabled = true;
            id = "ghostty";
          }
          {
            enabled = true;
            id = "yazi";
          }
          {
            enabled = true;
            id = "helix";
          }
          {
            enabled = true;
            id = "discord";
          }
          {
            enabled = true;
            id = "gtk";
          }
          {
            enabled = true;
            id = "qt";
          }
          {
            enabled = true;
            id = "zed";
          }
          {
            enabled = true;
            id = "pywalfox";
          }
        ];
        enableUserTheming = false;
      };

      nightLight = {
        enabled = true;
        forced = false;
        autoSchedule = true;
        nightTemp = "4791";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };

      hooks = {
        enabled = false;
        wallpaperChange = "";
        darkModeChange = "";
        screenLock = "";
        screenUnlock = "";
        performanceModeEnabled = "";
        performanceModeDisabled = "";
        startup = "";
        session = "";
        colorGeneration = "";
      };

      plugins = {
        autoUpdate = false;
        notifyUpdates = true;
      };

      idle = {
        enabled = true;
        screenOffTimeout = 300;
        lockTimeout = 310;
        suspendTimeout = 350;
        fadeDuration = 5;
        screenOffCommand = "";
        lockCommand = "";
        suspendCommand = "";
        resumeScreenOffCommand = "";
        resumeLockCommand = "";
        resumeSuspendCommand = "";
        customCommands = "[]";
      };

      desktopWidgets = {
        enabled = false;
        overviewEnabled = true;
        gridSnap = true;
        gridSnapScale = false;
        monitorWidgets = [
          {
            name = "eDP-1";
            widgets = [
              {
                id = "Clock";
                clockColor = "none";
                clockStyle = "minimal";
                customFont = "";
                format = "HH:mm\\nd MMMM yyyy";
                roundedCorners = true;
                scale = 1.1872543973407812;
                showBackground = true;
                useCustomFont = false;
                x = 1280;
                y = 300;
              }
              {
                id = "SystemStat";
                diskPath = "/";
                layout = "bottom";
                roundedCorners = true;
                scale = 1;
                showBackground = true;
                statType = "CPU";
                x = 1200;
                y = 400;
              }
              {
                id = "MediaPlayer";
                hideMode = "visible";
                roundedCorners = true;
                scale = 1;
                showAlbumArt = true;
                showBackground = true;
                showButtons = true;
                showVisualizer = true;
                visualizerType = "linear";
                x = 1060;
                y = 540;
              }
            ];
          }
        ];
      };
    };
  };
}
