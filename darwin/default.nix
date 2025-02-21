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
    inputs.nix-index-database.darwinModules.nix-index
    # ./${hostname}
  ];

  system.stateVersion = 4;

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
      #outputs.overlays.additions
      #outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # Add overlays exported from other flakes:
      # outputs.overlays.brew-nix
      inputs.brew-nix.overlays.default
    ];
  };

  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  networking.hostName = hostname;
  networking.computerName = hostname;

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

  # Enable TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  services = {
    nix-daemon.enable = true;
  };

  system = {
    # activationScripts run every time you boot the system or execute `darwin-rebuild`
    activationScripts = {
      diff = {
        supportsDryActivation = true;
        text = ''
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff /run/current-system "$systemConfig"
        '';
      };
      # reload the settings and apply them without the need to logout/login
      postUserActivation.text = ''
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
      # https://github.com/LnL7/nix-darwin/issues/881
      setFishAsShell.text = ''
        dscl . -create /Users/${username} UserShell /run/current-system/sw/bin/fish
      '';
    };
    checks = {
      verifyNixChannels = false;
    };
    defaults = {
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 0.6875; # set mouse tracking speed
        "com.apple.sound.beep.sound" = "/System/Library/Sounds/Tink.aiff"; # set alert sound to "Boop"
      };
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
        "company.thebrowser.Browser" = {
          arcMaxAutoOptInEnabled = 0;
          currentAppIconName = "candy";
          hasLaunchedBefore = 1;
        };
      };
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
      LaunchServices = {
        LSQuarantine = false;
      };
      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = false;
      };
      dock = {
        orientation = "bottom";
        persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/System/Applications/System Settings.app"
          "/System/Applications/Music.app"
          "/Users/${username}/Applications/Home Manager Apps/Arc.app"
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
  };
}
