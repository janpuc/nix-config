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
  ];

  system.stateVersion = 5;

  # Only install the docs I use
  documentation.enable = true;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = true;

  environment = {
    shells = [pkgs.fish];
    systemPackages = with pkgs; [
      git
      m-cli
      mas
      nix-output-monitor
      nvd
      plistwatch
      sops
    ];

    variables = {
      EDITOR = "nano";
      SYSTEMD_EDITOR = "nano";
      VISUAL = "nano";
    };
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${platform}";
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      #outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # Add overlays exported from other flakes:
      # outputs.overlays.brew-nix
      inputs.brew-nix.overlays.default
    ];
  };

  nix.enable = false; # Needed for new Nix Determinate default comming in 1st of January

  #  nix = {
  #    optimise.automatic = true;
  #    settings = {
  #      experimental-features = [
  #        "nix-command"
  #        "flakes"
  #      ];
  #      warn-dirty = false;
  #    };
  #  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "${username}";
  };

  networking.hostName = hostname;
  networking.computerName = hostname;

  programs = {
    _1password.enable = true;
    _1password-gui.enable = true;
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
    masApps = {
      # Apps
      "Steam Link" = 1246969117;
      "Tailscale" = 1470499037;
      # Safari addons
      "Kagi for Safari" = 1558453954;
      "wBlock" = 6746388723;
    };
  };

  # Enable TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    # activationScripts run every time you boot the system or execute `darwin-rebuild`
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
          "/System/Applications/Apps.app" # After Tahoe
          "/System/Applications/System Settings.app"
          "/System/Applications/Music.app"
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
        TrackpadThreeFingerDrag = true; # enable three finger drag
      };
    };
    primaryUser = "${username}";
  };
}
