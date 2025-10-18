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
}:
{
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
    activationScripts.postActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle when changing settings
      sudo -u ${username} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
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
      CustomSystemPreferences = { };

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
        # Keyboard Shortcuts
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Windows -> General -> Fill
            "237" = {
              enabled = true;
              value = {
                # Ctrl + Option + Enter
                parameters = [
                  65535
                  36
                  786432
                ];
                type = "standard";
              };
            };
            # Windows -> General -> Center
            "238" = {
              enabled = true;
              value = {
                # Ctrl + Option + \
                parameters = [
                  92
                  42
                  786432
                ];
                type = "standard";
              };
            };
            # Windows -> General -> Return to Previous Size
            "239" = {
              enabled = true;
              value = {
                # Ctrl + Option + /
                parameters = [
                  47
                  44
                  786432
                ];
                type = "standard";
              };
            };
            # Windows -> Halves -> Tile Left Half
            "240" = {
              enabled = true;
              value = {
                # Ctrl + Option + Left Arrow
                parameters = [
                  65535
                  123
                  9175040
                ];
                type = "standard";
              };
            };
            # Windows -> Halves -> Tile Right Half
            "241" = {
              enabled = true;
              value = {
                # Ctrl + Option + Right Arrow
                parameters = [
                  65535
                  124
                  9175040
                ];
                type = "standard";
              };
            };
            # Windows -> Halves -> Tile Top Half
            "242" = {
              enabled = true;
              value = {
                # Ctrl + Option + Up Arrow
                parameters = [
                  65535
                  126
                  9175040
                ];
                type = "standard";
              };
            };
            # Windows -> Halves -> Tile Bottom Half
            "243" = {
              enabled = true;
              value = {
                # Ctrl + Option + Down Arrow
                parameters = [
                  65535
                  125
                  9175040
                ];
                type = "standard";
              };
            };
          };
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
          "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
          "/Users/${username}/Applications/Home Manager Apps/Beeper Desktop.app"
          "/Users/${username}/Applications/Home Manager Apps/Microsoft Teams.app"
          "/Users/${username}/Applications/Home Manager Apps/Slack.app"
          "/Users/${username}/Applications/Home Manager Apps/Visual Studio Code.app"
          "/Users/${username}/Applications/Home Manager Apps/Ghostty.app"
          "/Applications/1Password.app"
          "/Users/${username}/Applications/Home Manager Apps/UTM.app"
        ];
        persistent-others = [ "/Users/${username}/Downloads" ];
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
