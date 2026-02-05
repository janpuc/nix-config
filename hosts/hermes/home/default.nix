{
  inputs,
  lib,
  outputs,
  pkgs,
  stateVersion,
  username,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.examle

    # Modules exported from other flakes:
    inputs._1password-shell-plugins.hmModules.default
    inputs.catppuccin.homeModules.catppuccin
    inputs.nix-index-database.homeModules.nix-index
    inputs.spicetify-nix.homeManagerModules.spicetify

    ../../../home-manager/config
    ../../../home-manager/programs
    ../../../home-manager/scripts

    # Common apps
    ../../../home-manager/apps/common/discord
    ../../../home-manager/apps/common/ghostty
    ../../../home-manager/apps/common/obsidian
    # ../../../home-manager/apps/common/prismlauncher
    ../../../home-manager/apps/common/slack
    ../../../home-manager/apps/common/spotify
    ../../../home-manager/apps/common/vscode
    # ../../../home-manager/apps/common/zed
    ../../../home-manager/apps/common/zoom-us

    # Darwin apps
    ../../../home-manager/apps/darwin/bambu-studio
    ../../../home-manager/apps/darwin/beeper
    ../../../home-manager/apps/darwin/microsoft-teams
    ../../../home-manager/apps/darwin/orbstack
    # ../../../home-manager/apps/darwin/proton-drive
    ../../../home-manager/apps/darwin/proton-vpn
    # ../../../home-manager/apps/darwin/raycast
    ../../../home-manager/apps/darwin/steam
    ../../../home-manager/apps/darwin/utm
  ];

  catppuccin = {
    accent = "blue";
    flavor = "mocha";
    atuin.enable = true;
    bat.enable = true;
    fish.enable = true;
    fzf.enable = true;
    k9s.enable = true;
    spotify-player.enable = true;
    starship.enable = true;
    vscode.profiles.default.enable = true;
    yazi.enable = true;
    # zed.enable = true;
  };

  home = {
    inherit stateVersion;
    inherit username;
    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

    preferXdgDirectories = true;

    # A Modern Unix expirience
    # https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
    packages =
      with pkgs;
      [
        oci-cli
        # terraform
        opentofu
        packer
        unstable.talosctl
        just

        alejandra
        pbzx
        yq-go

        # AWS
        aws-sso-cli
        gimme-aws-creds
        unstable.okta-aws-cli
        saml2aws

        # JavaScript/TypeScript
        bun
        nodejs_24

        # Kubernetes
        fluxcd
        helmfile
        k9s
        krew
        kubectl
        kubernetes-helm
        kustomize

        # Nix
        nixd
        nixfmt-rfc-style
        nil

        # Misc
        age # Modern file encryption
        android-tools # Android SDK platform tools
        clang-tools # Standalone command line tools for C++ development
        cocoapods
        cmake # Cross-platform, open-source build system generator
        gum # Tasty Bubble Gum for your shell
        minijinja # Template engine
        mtr # Network diagnostic tool
        ncdu
        unstable.opencode # AI coding agent built for the terminal
        parallel # Modern Unix `xargs`
        pkg-config # Tool that allows packages to find out information about other packages (wrapper script)
        speedtest-go # Terminal speedtest.net
        retry # Modern Unix `while`

        # sketchybar
        #asciicam # Terminal webcam #TODO: Move to linux only
        #asciinema-agg # Convert aciinema to .gif
        #asciinema # Terminal recorder
        # bc # Terminal calculator
        #bandwhich # Modern Unix `iftop`
        # bmon # Modern Unix `iftop`
        #breezy # Terminal bzr client
        #butler # Terminal Itch.io API client
        # chafa # Terminal image viewer
        # chroma # Code syntax highlighter
        # clinfo # Terminal OpenCL info
        # cpufetch # Terminal CPU info
        # croc # Terminal file transfer
        # curlie # Terminal HTTP client
        # cyme # Modern Unix `lsusb`
        # dconf2nix # Nix code from Dconf files
        # deadnix # Nix dead code finder
        # difftastic # Modern Unix `diff`
        # dogdns # Modern Unix `dig`
        # dotacat # Modern Unix lolcat
        # dua # Modern Unix `du`
        # duf # Modern Unix `df`
        # du-dust # Modern Unix `du`
        # editorconfig-core-c # EditorConfig Core
        # entr # Modern Unix `watch`
        # fastfetch # Modern Unix system info
        # fd # Modern Unix `find`
        # file # Terminal file info
        #frogmouth # Terminal mardown viewer
        # glow # Terminal Markdown renderer
        # girouette # Modern Unix weather
        # gocryptfs # Terminal encrypted filesystem
        # gping # Modern Unix `ping`
        # unstable.git-igitt # Moder Unix git log/graph
        # h # Modern Unix autojump for git projects
        # hexyl # Modern Unix `hexedit`
        # hr # Terminal horizontal rule
        #httpie # Terminal HTTP client #TODO: Broken
        #hueadm # Terminal Philips Hue client
        # hyperfine # Terminal benchmarking
        # iperf3 # Terminal network benchmarking
        # ipfetch # Terminal IP info
        #jpegoptim # Terminal JPEG otpimizer
        # jiq # Modern Unix `jq`
        #lastpass-cli # Terminal LastPass client
        #lima-bin # Terminal VM manager
        #marp-cli # Terminal Markdown presenter
        # mtr # Modern Unix `traceroute`
        # neo-cowsay # Terminal ASCII cows
        # netdiscover # Modern Unix `arp`
        # nixfmt-rfc-style # Nix code formatter
        # nixpkgs-review # Nix code review
        #nix-prefetch-scripts # Nix code fetcher TODO: Broken
        # nurl # Nix URL fetcher
        # nyancat # Terminal rainbow spewing feline
        # onefetch # Terminal git project info
        #optipng # Terminal PNG optimizer
        # procs # Modern Unix `ps`
        #quilt # Terminal patch manager
        # rclone # Modern Unix `rsync`
        # rsync # Traditional `rsync`
        # sd # Modern Unix `sed`
        # terminal-parrot # Terminal ASCII parrot
        #timer # Terminal timer
        # tldr # Modern Unix `man`
        # tokei # Modern Unix `wc` for code
        #tty-clock # Terminal clock
        #ueberzugpp # Terminal image viewer integration
        # unzip # Terminal ZIP extractor
        # upterm # Terminal sharing
        # wget # Terminal HTTP client
        # wget2 # Terminal HTTP client
        # wormhole-william # Terminal file transfer
        # yq-go # Terminal `jq` for YAML
      ]
      ++ lib.optionals isLinux [
        # figlet # Terminal ASCII banners
        # iw # Terminal WiFi info
        # lurk # Modern Unix `strace`
        # pciutils # Terminal PCI info
        # psmisc # Traditional `ps`
        # ramfetch # Terminal system info
        # s-tui # # Terminal CPU stress test
        # stress-ng # Terminal CPU stress test
        # usbutils # Terminal USB info
        # wavemon # Terminal WiFi monitor
        # writedisk # Modern Unix `dd`
        # zsync # Terminal file sync; FTBFS on aarch64-darwin
      ]
      ++ lib.optionals isDarwin [
        # m-cli # Terminal Swiss Army Knife for macOS
        nh
        # coreutils
      ];
    sessionVariables = {
      EDITOR = "nano";
      MANPAGER = ''
        sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'
      '';
      PAGER = "bat";
      SSH_AUTH_SOCK = "~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      SYSTEMD_EDITOR = "nano";
      VISUAL = "nano";

      OCI_CLI_RC_FILE = "~/.config/oci/config";
    };
    shellAliases = {
      # Nix aliases
      nix-darwin = "nh darwin switch ~/nix-config#darwinConfigurations.$(hostname)";
      nix-home = "nh home switch ~/nix-config";
      nix-update = "nix flake update";

      # Kubernetes aliases
      k = "kubectl";
      kx = "kubectx";
      ku = "kubectx -u";

      cat = "${pkgs.bat}/bin/bat --paging=never";
      less = "${pkgs.bat}/bin/bat";
      reload = "exec $SHELL -l";
      tree = "${pkgs.eza}/bin/eza --tree";
      ax = "awsx";
      awsu = "set -e AWS_PROFILE";
      au = "set -e AWS_PROFILE";
      unset = "set -e";
      unexport = "set -e";

      oci = ''op run --no-masking --env-file="/Users/${username}/.config/oci/op.env" -- oci'';
    };
  };

  fonts.fontconfig.enable = true;

  # Workaround home-manager bug with flakes
  # - https://github.com/nix-community/home-manager/issues/2033
  news.display = "silent";
  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.brew-nix
      inputs.brew-nix.overlays.default

      outputs.overlays.additions
      #outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "flakes nix-command";
      trusted-users = [
        "root"
        "${username}"
      ];
    };
  };
}
