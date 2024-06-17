{pkgs, ...}: {
  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts = {
      postUserActivation.text = ''
        # activateSettings -u will reload the settings from the database and apply them to the current session,
        # so we do not need to logout and login again to make the changes take effect.
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    };

    defaults = {
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 0.6875; # set mouse tracking speed
        "com.apple.sound.beep.sound" = "/System/Library/Sounds/Tink.aiff"; # set alert sound to "Boop"
      };

      ActivityMonitor = {
        IconType = 0; # set activity monitor icon type in the dock to default
        OpenMainWindow = true; # open main activity monitor window
      };

      LaunchServices.LSQuarantine = false; # disable unsafe application dialog

      # customize settings that are not supported by nix-darwin directly
      # Incomplete list of macOS `defaults` commands:
      #   https://github.com/yannbertrand/macos-defaults
      NSGlobalDomain = {
        AppleEnableMouseSwipeNavigateWithScrolls = true; # enable swiping to navigate backward or forward (mouse)
        AppleEnableSwipeNavigateWithScrolls = true; # enable swiping to navigate backward or forward

        AppleFontSmoothing = 1; # set font pixel smoothing

        AppleICUForce24HourTime = true; # set 24 hour time

        AppleInterfaceStyle = "Dark"; # dark mode
        AppleInterfaceStyleSwitchesAutomatically = false; # disable automatic mode switching

        AppleKeyboardUIMode = 3; # mode 3 enables full keyboard control

        AppleMeasurementUnits = "Centimeters"; # use metric measurement units
        AppleMetricUnits = 1; # use metric system

        ApplePressAndHoldEnabled = false; # disable press and hold

        AppleScrollerPagingBehavior = true; # click on the scrolling bar to jump on a page

        AppleShowScrollBars = "Automatic"; # automatically show scroll bars

        AppleTemperatureUnit = "Celsius"; # set temperature units

        AppleWindowTabbingMode = "fullscreen"; # set window tabbing

        # If you press and hold certain keyboard keys when in a text area, the key's character begins to repeat.
        # This is veru useful for vim users, they use `hjkl` to move cursor.
        # sets how long it takes before it starts repeating.
        InitialKeyRepeat = 10; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        # sets how fast it repeats once it starts.
        KeyRepeat = 1; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)

        NSAutomaticCapitalizationEnabled = false; # disable auto capitalization
        NSAutomaticDashSubstitutionEnabled = false; # disable auto dash substitution
        NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution
        NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution
        NSAutomaticSpellingCorrectionEnabled = false; # disable auto spelling correction

        NSAutomaticWindowAnimationsEnabled = false; # disable opening and closing animation

        NSDisableAutomaticTermination = true; # disable automatic termination of inactive apps

        NSDocumentSaveNewDocumentsToCloud = true; # enable automatic document sync with iCloud

        NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default
        NSNavPanelExpandedStateForSaveMode2 = true; # expand save panel by default

        NSScrollAnimationEnabled = true; # enable smooth scrolling

        NSTableViewDefaultSizeMode = 2; # set finder sidebar icons to medium

        NSTextShowsControlCharacters = true; # show control characters

        NSUseAnimatedFocusRing = false; # disable focus ring animation

        NSWindowResizeTime = 0.001; # speed up window resize speed
        NSWindowShouldDragOnGesture = true; # enable Linux-like window dragging

        PMPrintingExpandedStateForPrint = true; # expand print panel by default
        PMPrintingExpandedStateForPrint2 = true; # expand print panel by default

        _HIHideMenuBar = false; # disable menu bar autohide

        "com.apple.keyboard.fnState" = false; # hold fn for F1, F2 etc. keys

        "com.apple.mouse.tapBehavior" = 1; # enable tap to click

        "com.apple.sound.beep.feedback" = 0; # disable beep sound when pressing volume up/down key
        "com.apple.sound.beep.volume" = 1.0; # set beep sound to 100% of the volume

        "com.apple.springing.delay" = 0.0; # disable spring loading delay for directories
        "com.apple.springing.enabled" = true; # enable spring loading for directories

        "com.apple.swipescrolldirection" = true; # enable natural scrolling

        "com.apple.trackpad.enableSecondaryClick" = true; # enable two finger right click
        "com.apple.trackpad.forceClick" = true; # enable force click
        "com.apple.trackpad.scaling" = 0.6875; # set tracking speed
        "com.apple.trackpad.trackpadCornerClickBehavior" = null; # disable right click on corner click
      };

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false; # disable automatic MacOS updates

      alf = {
        allowdownloadsignedenabled = 1; # allow downloaded signed applications to accept incoming requests
        allowsignedenabled = 1; # allow signed applications to accept incoming requests
        globalstate = 1; # enable firewall
        loggingenabled = 0; # disable logging requests made to firewall
        stealthenabled = 1; # drop ICMP requests (ex. ping)
      };

      # customize dock
      dock = {
        enable-spring-load-actions-on-all-items = true; # enable spring loading for all dock items
        appswitcher-all-displays = false; # display app switcher only on the main display
        autohide = true; # autohide dock
        autohide-delay = 0.0; # disable autohide delay
        autohide-time-modifier = 0.0; # disable the autohide animation
        dashboard-in-overlay = true; # don't show dashboard as a space
        expose-animation-duration = 0.1; # speed up mission control animation
        expose-group-by-app = false; # disable grouping apps in mission control
        largesize = 16; # magnified icon size on hover
        launchanim = false; # disable apps opening
        magnification = false; # disable icon magnification on hover
        mineffect = "scale"; # set minimize/maximize window effect
        minimize-to-application = true; # minimize apps to their icon
        mouse-over-hilite-stack = true; # enable highlight hover effect for grid view of a stack
        mru-spaces = false; # don't automatically rearange spaces based on use
        orientation = "bottom"; # set dock position
        show-process-indicators = true; # show indicator lights for open applications
        show-recents = false; # disable recent apps
        showhidden = true; # show hidden aplications as translucent
        static-only = false; # don't show only open apps in the dock
        tilesize = 64; # set icon size

        # Hot Corners
        # Possible values:
        #  1: Disabled
        #  2: Mission Control
        #  3: Show application windows
        #  4: Desktop
        #  5: Start screen saver
        #  6: Disable screen saver
        #  7: Dashboard
        # 10: Put display to sleep
        # 11: Launchpad
        # 12: Notification Center
        # 13: Lock Screen
        # 14: Quick Note
        wvous-bl-corner = 5; # bottom-left  → Start screen saver
        wvous-br-corner = 3; # bottom-right → Show application windows
        wvous-tl-corner = 2; # top-left     → Mission Control
        wvous-tr-corner = 4; # top-right    → Desktop
      };

      # customize finder
      finder = {
        AppleShowAllExtensions = true; # show all file extensions
        AppleShowAllFiles = true; # show hidden files
        CreateDesktop = true; # show icons on the desktop
        FXDefaultSearchScope = null; # don't change the default search scope
        FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
        FXPreferredViewStyle = "Nlsv"; # set default finder view to list
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
        _FXShowPosixPathInTitle = true; # show full path in finder title
      };

      # customize login window
      loginwindow = {
        DisableConsoleAccess = false; # allow console access
        GuestEnabled = false; # disable guest user
        LoginwindowText = "\\U03bb"; # use default login window text
        PowerOffDisabledWhileLoggedIn = false; # allow power off if user is logged in
        RestartDisabled = false; # don't hide restart button
        RestartDisabledWhileLoggedIn = false; # allow restart if user is logged in
        SHOWFULLNAME = false; # list users in login window
        ShutDownDisabled = false; # don't hide shutdown button
        ShutDownDisabledWhileLoggedIn = false; # allow shutdown if user is logged in
        SleepDisabled = false; # don't hide sleep button
        autoLoginUser = null; # don't automatically login
      };

      # customize clock
      menuExtraClock = {
        IsAnalog = false; # show digital clock
        Show24Hour = true; # show 24 hour clock
        ShowAMPM = false; # don't show AM/PM label
        ShowDate = 1; # always show date
        ShowDayOfMonth = true; # show day of the month
        ShowDayOfWeek = true; # show day of the week
        ShowSeconds = true; # show seconds
      };

      # customize screen capture
      screencapture = {
        disable-shadow = true; # disable shadow border
        location = "~/Desktop"; # save file location
        type = "png"; # save as png
      };

      # customize screen saver
      screensaver = {
        askForPassword = true; # ask for password after screen saver starts
        askForPasswordDelay = 0; # require password immediately
      };

      # customize trackpad
      trackpad = {
        ActuationStrength = 1; # disable silent clicking
        Clicking = true; # enable tap to click
        Dragging = false; # disable tap to drag
        FirstClickThreshold = 1; # set click threshold to medium
        SecondClickThreshold = 1; # set force click threshold to medium
        TrackpadRightClick = true; # enable two finger right click
        #        TrackpadThreeFingerDrag = true; # enable three finger drag
        #        TrackpadThreeFingerTapGesture = 2; # enable three finger tap
      };

      # Customize settings that not supported by nix-darwin directly
      # see the source code of this project to get more undocumented options:
      #    https://github.com/rgcr/m-cli
      #
      # All custom entries can be found by running `defaults read` command.
      # or `defaults read xxx` to read a specific domain.
      CustomUserPreferences = {
        "com.knollsoft.Rectangle" = {
          SUEnableAutomaticChecks = 0;
          SUHasLaunchedBefore = 1;
          alternateDefaultShortcuts = 1;
          hapticFeedbackOnSnap = 1;
          hideMenubarIcon = 1;
          landscapeSnapAreas = null;
          launchOnLogin = 1;
          portraitSnapAreas = null;
          reflowTodo = {
            keyCode = 45;
            modifierFlags = 786432;
          };
          toggleTodo = {
            keyCode = 11;
            modifierFlags = 786432;
          };
        };
      };
    };

    # customize keyboard
    keyboard = {
      enableKeyMapping = true; # enable key maping so that we can use `option` as `control`
      nonUS.remapTilde = false; # disable tilde key remap on non-us keyboards
      remapCapsLockToControl = false; # don't remap capslock to control
      remapCapsLockToEscape = false; # don't remap capslock to escape
      swapLeftCommandAndLeftAlt = false; # don't swap left command and alt keys
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  time.timeZone = "Europe/Warsaw";

  fonts = {
    packages = with pkgs; [
      material-design-icons
      font-awesome

      (nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
    ];
  };
}
