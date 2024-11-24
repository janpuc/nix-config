{
  config,
  inputs,
  isWorkstation,
  lib,
  outputs,
  pkgs,
  stateVersion,
  username,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  imports =
    [
      # If you want to use modules your own flake exports (from modules/home-manager):
      # outputs.homeManagerModules.examle

      # Modules exported from other flakes:
      inputs.catppuccin.homeManagerModules.catppuccin
      inputs.nix-index-database.hmModules.nix-index
    ]
    ++ lib.optional isWorkstation ./_mixins/desktop;

  catppuccin = {
    accent = "blue";
    flavor = "mocha";
  };

  home = {
    inherit stateVersion;
    inherit username;
    homeDirectory =
      if isDarwin
      then "/Users/${username}"
      else "/home/${username}";

    file = {};

    # A Modern Unix expirience
    # https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/
    packages = with pkgs;
      [
        #asciicam # Terminal webcam #TODO: Move to linux only
        #asciinema-agg # Convert aciinema to .gif
        #asciinema # Terminal recorder
        bc # Terminal calculator
        #bandwhich # Modern Unix `iftop`
        bmon # Modern Unix `iftop`
        #breezy # Terminal bzr client
        #butler # Terminal Itch.io API client
        chafa # Terminal image viewer
        chroma # Code syntax highlighter
        clinfo # Terminal OpenCL info
        cpufetch # Terminal CPU info
        croc # Terminal file transfer
        curlie # Terminal HTTP client
        cyme # Modern Unix `lsusb`
        dconf2nix # Nix code from Dconf files
        deadnix # Nix dead code finder
        difftastic # Modern Unix `diff`
        dogdns # Modern Unix `dig`
        dotacat # Modern Unix lolcat
        dua # Modern Unix `du`
        duf # Modern Unix `df`
        du-dust # Modern Unix `du`
        editorconfig-core-c # EditorConfig Core
        entr # Modern Unix `watch`
        fastfetch # Modern Unix system info
        fd # Modern Unix `find`
        file # Terminal file info
        #frogmouth # Terminal mardown viewer
        glow # Terminal Markdown renderer
        girouette # Modern Unix weather
        gocryptfs # Terminal encrypted filesystem
        gping # Modern Unix `ping`
        unstable.git-igitt # Moder Unix git log/graph
        h # Modern Unix autojump for git projects
        hexyl # Modern Unix `hexedit`
        hr # Terminal horizontal rule
        #httpie # Terminal HTTP client #TODO: Broken
        #hueadm # Terminal Philips Hue client
        hyperfine # Terminal benchmarking
        iperf3 # Terminal network benchmarking
        ipfetch # Terminal IP info
        #jpegoptim # Terminal JPEG otpimizer
        jiq # Modern Unix `jq`
        #lastpass-cli # Terminal LastPass client
        #lima-bin # Terminal VM manager
        #marp-cli # Terminal Markdown presenter
        mtr # Modern Unix `traceroute`
        neo-cowsay # Terminal ASCII cows
        netdiscover # Modern Unix `arp`
        nixfmt-rfc-style # Nix code formatter
        nixpkgs-review # Nix code review
        #nix-prefetch-scripts # Nix code fetcher TODO: Broken
        nurl # Nix URL fetcher
        nyancat # Terminal rainbow spewing feline
        onefetch # Terminal git project info
        #optipng # Terminal PNG optimizer
        procs # Modern Unix `ps`
        #quilt # Terminal patch manager
        rclone # Modern Unix `rsync`
        rsync # Traditional `rsync`
        sd # Modern Unix `sed`
        speedtest-go # Terminal speedtest.net
        terminal-parrot # Terminal ASCII parrot
        #timer # Terminal timer
        tldr # Modern Unix `man`
        tokei # Modern Unix `wc` for code
        #tty-clock # Terminal clock
        #ueberzugpp # Terminal image viewer integration
        unzip # Terminal ZIP extractor
        upterm # Terminal sharing
        wget # Terminal HTTP client
        wget2 # Terminal HTTP client
        wormhole-william # Terminal file transfer
        yq-go # Terminal `jq` for YAML
      ]
      ++ lib.optionals isLinux [
        figlet # Terminal ASCII banners
        iw # Terminal WiFi info
        lurk # Modern Unix `strace`
        pciutils # Terminal PCI info
        psmisc # Traditional `ps`
        ramfetch # Terminal system info
        s-tui # # Terminal CPU stress test
        stress-ng # Terminal CPU stress test
        usbutils # Terminal USB info
        wavemon # Terminal WiFi monitor
        writedisk # Modern Unix `dd`
        zsync # Terminal file sync; FTBFS on aarch64-darwin
      ]
      ++ lib.optionals isDarwin [
        m-cli # Terminal Swiss Army Knife for macOS
        nh
        coreutils
      ];
    sessionVariables = {
      EDITOR = "micro";
      MANPAGER = "sh -c 'col --no-backspaces --spaces | bat --language man'";
      MANROFFOPT = "-c";
      MICRO_TRUECOLOR = "1";
      PAGER = "bat";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";
    };
  };

  fonts.fontconfig.enable = true;

  # Workaround home-manager bug with flakes
  # - https://github.com/nix-community/home-manager/issues/2033
  news.display = "silent";
  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      #outputs.overlays.additions
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

  programs = {
    aria2.enable = true;
    bat = {
      catppuccin.enable = true;
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
        batwatch
        prettybat
      ];
      config = {
        style = "plain";
      };
    };
    bottom = {
      catppuccin.enable = true;
      enable = true;
      settings = {
        disk_filter = {
          is_list_ingored = true;
          list = ["/dev/loop"];
          regex = true;
          case_sensitive = false;
          whole_word = false;
        };
        flags = {
          dot_marker = false;
          enable_gpu_memory = true;
          group_processes = true;
          hide_table_gap = true;
          mem_as_value = true;
          tree = true;
        };
      };
    };
    cava = {
      catppuccin.enable = true;
      enable = isLinux;
    };
    dircolors = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
      };
    };
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = true;
    };
    fish = {
      catppuccin.enable = true;
      enable = true;
      shellAliases = {
        banner = lib.mkIf isLinux "${pkgs.figlet}/bin/figlet";
        banner-color = lib.mkIf isLinux "${pkgs.figlet}/bin/figlet $argv | ${pkgs.dotacat}/bin/dotacat";
        brg = "${pkgs.bat-extras.batgrep}/bin/batgrep";
        cat = "${pkgs.bat}/bin/bat --paging=never";
        #clock = ''${pkgs.tty-clock}/bin/tty-clock -B -c -C 4 -f "%a, %d %b"'';
        dadjoke = ''${pkgs.curlMinimal}/bin/curl --header "Accept: text/plain https://icanhazdadjoke.com/"'';
        dmesg = "${pkgs.util-linux}/bin/dmesg --human --color=always";
        neofetch = "${pkgs.fastfetch}/bin/fastfetch";
        #glow = "${pkgs.glow}/bin/glow --pager";
        hr = ''${pkgs.hr}/bin/hr "─━"'';
        htop = "${pkgs.bottom}/bin/btm --basic --tree --hide_table_gap --dot_marker --mem_as_value";
        ip = lib.mkIf isLinux "${pkgs.iproute2}/bin/ip --color -brief";
        less = "${pkgs.bat}/bin/bat";
        #lm = "${pkgs.lima-bin}/bin/limactl";
        lolcat = "${pkgs.dotacat}/bin/dotacat";
        moon = "${pkgs.curlMinimal}/bin/curl -s wttr.in/Moon";
        more = "${pkgs.bat}/bin/bat";
        parrot = "${pkgs.terminal-parrot}/bin/terminal-parrot -delay 50 -loops 7";
        ruler = ''${pkgs.hr}/bin/hr "╭─³⁴⁵⁶⁷⁸─╮"'';
        screenfetch = "${pkgs.fastfetch}/bin/fastfetch";
        speedtest = "${pkgs.speedtest-go}/bin/speedtest-go";
        store-path = "${pkgs.coreutils-full}/bin/readlink (${pkgs.which}/bin/which $argv)";
        top = "${pkgs.bottom}/bin/btm --basic --tree --hide_table_gap --dot_marker --mem_as_value";
        tree = "${pkgs.eza}/bin/eza --tree";
        wormhole = "${pkgs.wormhole-william}/bin/wormhole-william";
        weather = "${lib.getExe pkgs.girouette} --quiet";
        weather-home = "${lib.getExe pkgs.girouette} --quiet --location Krakow";
        where-am-i = "${pkgs.geoclue2}/libexec/geoclue-2.0/demos/where-am-i";
      };
    };
    fzf = {
      catppuccin.enable = true;
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
    gh = {
      enable = true;
      extensions = with pkgs; [
        gh-dash
        gh-markdown-preview
      ];
      settings = {
        editor = "micro";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
    git = {
      enable = true;
      aliases = {
        ci = "commit";
        cl = "clone";
        co = "checkout";
        purr = "pull --rebase";
        dlog = "!f() { GIT_EXTERNAL_DIFF=difft git log -p --ext-diff $@ }; f";
        dshow = "!f() { GIT_EXTERNAL_DIFF=difft git show --ext-diff $@ }; f";
        fucked = "reset --hard";
        graph = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
      difftastic = {
        display = "side-by-side-show-both";
        enable = true;
      };
      extraConfig = {
        advice = {
          statusHints = false;
        };
        color = {
          branch = false;
          diff = false;
          interactive = true;
          log = false;
          status = true;
          ui = false;
        };
        core = {
          pager = "bat";
        };
        push = {
          default = "matching";
        };
        pull = {
          rebase = false;
        };
        init = {
          defaultBranch = "main";
        };
      };
      ignores = [
        "*.log"
        "*.out"
        ".DS_Store"
        "bin/"
        "dist/"
        "result"
      ];
    };
    gitui = {
      catppuccin.enable = true;
      enable = true;
    };
    gpg.enable = true;
    home-manager.enable = true;
    info.enable = true;
    jq.enable = true;
    micro = {
      catppuccin.enable = true;
      enable = true;
      settings = {
        autosu = true;
        diffgutter = true;
        paste = true;
        rmtrailingws = true;
        savecursor = true;
        saveundo = true;
        scrollbar = true;
        scrollbarchar = "░";
        scrollmargin = 4;
        scrollspeed = 1;
      };
    };
    nix-index.enable = true;
    powerline-go = {
      enable = true;
      settings = {
        cwd-max-depth = 5;
        cwd-max-dir-size = 12;
        theme = "gruvbox";
        max-width = 60;
      };
    };
    ripgrep = {
      arguments = [
        "--colors=line:style:bold"
        "--max-columns-preview"
        "--smart-case"
      ];
      enable = true;
    };
    tmate.enable = true;
    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      catppuccin.enable = true;
      settings = {
        manager = {
          show_hidden = false;
          show_symlink = true;
          sort_by = "natural";
          sort_dir_first = true;
          sort_sensitive = false;
          sort_reverse = false;
        };
      };
    };
    yt-dlp = {
      enable = true;
      settings = {
        audio-format = "best";
        audio-quality = 0;
        embed-chapters = true;
        embed-metadata = true;
        embed-subs = true;
        embed-thumbnail = true;
        remux-video = "aac>m4a/mov>mp4/mkv";
        sponsorblock-mark = "sponsor";
        sub-langs = "all";
      };
    };
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      # Replace cd with z and add cdi to access zi
      options = ["--cmd cd"];
    };
  };
}
