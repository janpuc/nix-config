{
  config,
  hostname,
  inputs,
  lib,
  outputs,
  pkgs,
  platform,
  username,
  ...
}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.nix-index-database.darwinModules.nix-index
    ../common
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "${username}";
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${platform}";
    overlays = [
      outputs.overlays.additions
      outputs.overlays.unstable-packages
      inputs.brew-nix.overlays.default
    ];
  };

  programs = {
    fish = {
      enable = true;
      # shellAliases = {
      #   nano = "micro";
      # };
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    info.enable = false;
    nix-index-database.comma.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  # Enable TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    # Nix-darwin does not link installed applications to the user environment. This means apps will not show up
    # in spotlight, and when launched through the dock they come with a terminal window. This is a workaround.
    # Upstream issue: https://github.com/LnL7/nix-darwin/issues/214
    activationScripts.applications.text = lib.mkForce ''
      echo "setting up ~/Applications..." >&2
      applications="$HOME/Applications"
      nix_apps="$applications/Nix Apps"

      # Needs to be writable by the user so that home-manager can symlink into it
      if ! test -d "$applications"; then
          mkdir -p "$applications"
          chown ${username}: "$applications"
          chmod u+w "$applications"
      fi

      # Delete the directory to remove old links
      rm -rf "$nix_apps"
      mkdir -p "$nix_apps"
      find ${config.system.build.applications}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read src; do
              # Spotlight does not recognize symlinks, it will ignore directory we link to the applications folder.
              # It does understand MacOS aliases though, a unique filesystem feature. Sadly they cannot be created
              # from bash (as far as I know), so we use the oh-so-great Apple Script instead.
              /usr/bin/osascript -e "
                  set fileToAlias to POSIX file \"$src\"
                  set applicationsFolder to POSIX file \"$nix_apps\"
                  tell application \"Finder\"
                      make alias file to fileToAlias at applicationsFolder
                      # This renames the alias; 'mpv.app alias' -> 'mpv.app'
                      set name of result to \"$(rev <<< "$src" | cut -d'/' -f1 | rev)\"
                  end tell
              " 1>/dev/null
          done
    '';
    defaults = {
      ".GlobalPreferences" = {
        ## Sets the mouse tracking speed. Found in the “Mouse” section of “System Preferences”. Set to -1.0 to disable mouse
        ## acceleration.
        ##
        ## Type: null or floating point number
        ## Default: null
        ## Example: -1.0
        "com.apple.mouse.scaling" = 0.6875;

        ## Sets the system-wide alert sound. Found under “Sound Effects” in the “Sound” section of “System Preferences”. Look in
        ## “/System/Library/Sounds” for possible candidates.
        ##
        ## Type: null or absolute path
        ## Default: null
        "com.apple.sound.beep.sound" = "/System/Library/Sounds/Tink.aiff";
      };
      ActivityMonitor = {
        ## Change the icon in the dock when running.
        ## - 0: Application Icon
        ## - 2: Network Usage
        ## - 3: Disk Activity
        ## - 5: CPU Usage
        ## - 6: CPU History Default is null.
        ##
        ## Type: null or signed integer
        ## Default: null
        IconType = null;

        ## Open the main window when opening Activity Monitor. Default is true.
        ##
        ## Type: null or boolean
        ## Default: null
        OpenMainWindow = null;

        ## Change which processes to show.
        ## - 100: All Processes
        ## - 101: All Processes, Hierarchally
        ## - 102: My Processes
        ## - 103: System Processes
        ## - 104: Other User Processes
        ## - 105: Active Processes
        ## - 106: Inactive Processes
        ## - 107: Windowed Processes Default is 100.
        ##
        ## Type: null or one of 100, 101, 102, 103, 104, 105, 106, 107
        ## Default: null
        ShowCategory = null;

        ## Which column to sort the main activity page (such as “CPUUsage”). Default is null.
        ##
        ## Type: null or string
        ## Default: null
        SortColumn = null;

        ## The sort direction of the sort column (0 is decending). Default is null.
        ##
        ## Type: null or signed integer
        ## Default: null
        SortDirection = null;
      };

      ## Sets custom system preferences
      ##
      ## Type: plist value
      ## Default: { }
      ## Example:
      ## ```
      ## {
      ##   NSGlobalDomain = {
      ##     TISRomanSwitchState = 1;
      ##   };
      ##   "com.apple.Safari" = {
      ##     "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      ##   };
      ## }
      ## ```
      CustomSystemPreferences = {};

      ## Sets custom user preferences
      ##
      ## Type: plist value
      ## Default: { }
      ## Example:
      ## ```
      ## {
      ##   NSGlobalDomain = {
      ##     TISRomanSwitchState = 1;
      ##   };
      ##   "com.apple.Safari" = {
      ##     "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      ##   };
      ## }
      ## ```
      CustomUserPreferences = {
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        "com.apple.controlcenter" = {
          BatteryShowPercentage = true;
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.finder" = {
          _FXSortFoldersFirst = true;
          FXDefaultSearchScope = "SCcf"; # Search current folder by default
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
        };
        # Prevent Photos from opening automatically
        "com.apple.ImageCapture".disableHotPlug = true;
        "com.apple.screencapture" = {
          location = "~/Pictures/Screenshots";
          type = "png";
        };
        "com.apple.SoftwareUpdate" = {
          AutomaticCheckEnabled = true;
          # Check for software updates daily, not just once per week
          ScheduleFrequency = 1;
          # Download newly available updates in background
          AutomaticDownload = 0;
          # Install System data files & security updates;
          CriticalUpdateInstall = 1;
        };
        "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
        # Turn on app auto-update
        "com.apple.commerce".autoUpdate = true;
        NSGlobalDomain = {
          NSStatusItemSelectionPadding = 6;
          NSStatusItemSpacing = 6;
        };
      };

      ## Whether to enable quarantine for downloaded applications. The default is true.
      ##
      ## Type: null or boolean
      ## Default: null
      LaunchServices.LSQuarantine = false;

      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        # AppleIconAppearanceTheme = "ClearDark"; # After nix-darwin 25.11 is released
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = true;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = false;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        launchanim = false;
        orientation = "bottom";
        persistent-apps = [
          "/System/Applications/Apps.app"
          "/System/Applications/System Settings.app"
          "/Users/${username}/Applications/Home Manager Apps/Spotify.app"
          "/Applications/Safari.app"
          "/Users/${username}/Applications/Home Manager Apps/Beeper Desktop.app"
          "/Users/${username}/Applications/Home Manager Apps/Microsoft Teams.app"
          "/Users/${username}/Applications/Home Manager Apps/Slack.app"
          "/Users/${username}/Applications/Home Manager Apps/Visual Studio Code.app"
          "/Users/${username}/Applications/Home Manager Apps/Ghostty.app"
          "/Applications/1Password.app"
          "/Users/${username}/Applications/Home Manager Apps/UTM.app"
        ];
        persistent-others = ["/Users/${username}/Downloads"];
        show-recents = false;
        tilesize = 48;
        # Disable hot corners
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      menuExtraClock = {
        ShowAMPM = false;
        ShowDate = 1; # Always
        Show24Hour = true;
        ShowSeconds = true;
      };
      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 300;
      };
      smb.NetBIOSName = hostname;
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = false; # disable three finger drag
        TrackpadThreeFingerTapGesture = 2;
      };
    };
    primaryUser = "${username}";
  };
}
