{
  config,
  lib,
  pkgs,
  ...
}:
let
  theme_url = "https://raw.githubusercontent.com/catppuccin/spicetify/4294a61f54a044768c6e9db20e83c5b74da71091";
  theme_dir = "${config.xdg.configHome}/spicetify/Themes";

  themeFilesList = [
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-blue.gif";
    #   hash = "sha256-T9t37fCv9qM0BjV0Ob9v29GznPMSwa1/0mYGDN1BwUI=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-flamingo.gif";
    #   hash = "sha256-lYRicFoU/RzQWd/brY9xUy56L1CDvaIu4/eyLtwnQCo=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-green.gif";
    #   hash = "sha256-S59sxvZfiaO6YayKonUiDsSQkgMVYOkE3a0yTh0nEN8=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-lavender.gif";
    #   hash = "sha256-e5DP7GvQOwwb0vKAvff4/Hjr16JuqOsVCVAjhcOLGug=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-maroon.gif";
    #   hash = "sha256-OyuEw414a5bwhXFOp/nMTV89C0s8Rses4b3nfThU0Kc=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-mauve.gif";
    #   hash = "sha256-SWj4uneGCuiJZW0BhqiWMgQNSNQwWtfNS59SMJokuak=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-peach.gif";
    #   hash = "sha256-ndB91wkzKedllHi9GdMsomEvLPZmp+OY2MFNX0BM56U=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-pink.gif";
    #   hash = "sha256-qhiOzgc4IK2Xjr2/5emGFzoasOrVvXNZsWgmbRUxgdA=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-red.gif";
    #   hash = "sha256-Tut0h3KnGZgyDxbFpo0CoiblbDVUv3eqS85UD6lEFkM=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-rosewater.gif";
    #   hash = "sha256-etAfQc8xDfZNRWwlHpElhTg2hsN4NBJV+wl2JieTiQE=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-sapphire.gif";
    #   hash = "sha256-8S2noXTGwI4zuX6Kmt0O+8a738dMOORSdR8PvabB5w4=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-sky.gif";
    #   hash = "sha256-I3Bp3AY4C4zQElQ7mN4XiLvTej0StGLHvUDYAdGITQw=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-teal.gif";
    #   hash = "sha256-hYusT5T4Iaw6ZG/ZfguCdDkhfyCGKTJdzRBxAvAGO+Y=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-text.gif";
    #   hash = "sha256-2h1UULi4nbmE9pdfDoA6kYurRjlt1sDk3f+Y3jxMCqU=";
    # }
    # {
    #   path = "catppuccin/assets/frappe/equalizer-animated-yellow.gif";
    #   hash = "sha256-5ufc+ZdQfnS2ks7LPPU5v9BC37V+kQG2aXjDW7jfsB4=";
    # }

    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-blue.gif";
    #   hash = "sha256-T9t37fCv9qM0BjV0Ob9v29GznPMSwa1/0mYGDN1BwUI=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-flamingo.gif";
    #   hash = "sha256-lYRicFoU/RzQWd/brY9xUy56L1CDvaIu4/eyLtwnQCo=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-green.gif";
    #   hash = "sha256-S59sxvZfiaO6YayKonUiDsSQkgMVYOkE3a0yTh0nEN8=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-lavender.gif";
    #   hash = "sha256-e5DP7GvQOwwb0vKAvff4/Hjr16JuqOsVCVAjhcOLGug=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-maroon.gif";
    #   hash = "sha256-OyuEw414a5bwhXFOp/nMTV89C0s8Rses4b3nfThU0Kc=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-mauve.gif";
    #   hash = "sha256-SWj4uneGCuiJZW0BhqiWMgQNSNQwWtfNS59SMJokuak=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-peach.gif";
    #   hash = "sha256-ndB91wkzKedllHi9GdMsomEvLPZmp+OY2MFNX0BM56U=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-pink.gif";
    #   hash = "sha256-qhiOzgc4IK2Xjr2/5emGFzoasOrVvXNZsWgmbRUxgdA=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-red.gif";
    #   hash = "sha256-Tut0h3KnGZgyDxbFpo0CoiblbDVUv3eqS85UD6lEFkM=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-rosewater.gif";
    #   hash = "sha256-etAfQc8xDfZNRWwlHpElhTg2hsN4NBJV+wl2JieTiQE=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-sapphire.gif";
    #   hash = "sha256-8S2noXTGwI4zuX6Kmt0O+8a738dMOORSdR8PvabB5w4=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-sky.gif";
    #   hash = "sha256-I3Bp3AY4C4zQElQ7mN4XiLvTej0StGLHvUDYAdGITQw=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-teal.gif";
    #   hash = "sha256-hYusT5T4Iaw6ZG/ZfguCdDkhfyCGKTJdzRBxAvAGO+Y=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-text.gif";
    #   hash = "sha256-2h1UULi4nbmE9pdfDoA6kYurRjlt1sDk3f+Y3jxMCqU=";
    # }
    # {
    #   path = "catppuccin/assets/latte/equalizer-animated-yellow.gif";
    #   hash = "sha256-5ufc+ZdQfnS2ks7LPPU5v9BC37V+kQG2aXjDW7jfsB4=";
    # }

    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-blue.gif";
    #   hash = "sha256-T9t37fCv9qM0BjV0Ob9v29GznPMSwa1/0mYGDN1BwUI=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-flamingo.gif";
    #   hash = "sha256-lYRicFoU/RzQWd/brY9xUy56L1CDvaIu4/eyLtwnQCo=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-green.gif";
    #   hash = "sha256-S59sxvZfiaO6YayKonUiDsSQkgMVYOkE3a0yTh0nEN8=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-lavender.gif";
    #   hash = "sha256-e5DP7GvQOwwb0vKAvff4/Hjr16JuqOsVCVAjhcOLGug=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-maroon.gif";
    #   hash = "sha256-OyuEw414a5bwhXFOp/nMTV89C0s8Rses4b3nfThU0Kc=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-mauve.gif";
    #   hash = "sha256-SWj4uneGCuiJZW0BhqiWMgQNSNQwWtfNS59SMJokuak=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-peach.gif";
    #   hash = "sha256-ndB91wkzKedllHi9GdMsomEvLPZmp+OY2MFNX0BM56U=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-pink.gif";
    #   hash = "sha256-qhiOzgc4IK2Xjr2/5emGFzoasOrVvXNZsWgmbRUxgdA=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-red.gif";
    #   hash = "sha256-Tut0h3KnGZgyDxbFpo0CoiblbDVUv3eqS85UD6lEFkM=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-rosewater.gif";
    #   hash = "sha256-etAfQc8xDfZNRWwlHpElhTg2hsN4NBJV+wl2JieTiQE=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-sapphire.gif";
    #   hash = "sha256-8S2noXTGwI4zuX6Kmt0O+8a738dMOORSdR8PvabB5w4=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-sky.gif";
    #   hash = "sha256-I3Bp3AY4C4zQElQ7mN4XiLvTej0StGLHvUDYAdGITQw=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-teal.gif";
    #   hash = "sha256-hYusT5T4Iaw6ZG/ZfguCdDkhfyCGKTJdzRBxAvAGO+Y=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-text.gif";
    #   hash = "sha256-2h1UULi4nbmE9pdfDoA6kYurRjlt1sDk3f+Y3jxMCqU=";
    # }
    # {
    #   path = "catppuccin/assets/macchiato/equalizer-animated-yellow.gif";
    #   hash = "sha256-5ufc+ZdQfnS2ks7LPPU5v9BC37V+kQG2aXjDW7jfsB4=";
    # }

    {
      path = "catppuccin/assets/mocha/equalizer-animated-blue.gif";
      hash = "sha256-T9t37fCv9qM0BjV0Ob9v29GznPMSwa1/0mYGDN1BwUI=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-flamingo.gif";
      hash = "sha256-lYRicFoU/RzQWd/brY9xUy56L1CDvaIu4/eyLtwnQCo=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-green.gif";
      hash = "sha256-S59sxvZfiaO6YayKonUiDsSQkgMVYOkE3a0yTh0nEN8=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-lavender.gif";
      hash = "sha256-e5DP7GvQOwwb0vKAvff4/Hjr16JuqOsVCVAjhcOLGug=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-maroon.gif";
      hash = "sha256-OyuEw414a5bwhXFOp/nMTV89C0s8Rses4b3nfThU0Kc=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-mauve.gif";
      hash = "sha256-SWj4uneGCuiJZW0BhqiWMgQNSNQwWtfNS59SMJokuak=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-peach.gif";
      hash = "sha256-ndB91wkzKedllHi9GdMsomEvLPZmp+OY2MFNX0BM56U=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-pink.gif";
      hash = "sha256-1TkK7P5Rkkxx7uQipiKci7ApYO/EvxQDq18YqOpSibw=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-red.gif";
      hash = "sha256-Tut0h3KnGZgyDxbFpo0CoiblbDVUv3eqS85UD6lEFkM=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-rosewater.gif";
      hash = "sha256-etAfQc8xDfZNRWwlHpElhTg2hsN4NBJV+wl2JieTiQE=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-sapphire.gif";
      hash = "sha256-8S2noXTGwI4zuX6Kmt0O+8a738dMOORSdR8PvabB5w4=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-sky.gif";
      hash = "sha256-I3Bp3AY4C4zQElQ7mN4XiLvTej0StGLHvUDYAdGITQw=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-teal.gif";
      hash = "sha256-hYusT5T4Iaw6ZG/ZfguCdDkhfyCGKTJdzRBxAvAGO+Y=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-text.gif";
      hash = "sha256-2h1UULi4nbmE9pdfDoA6kYurRjlt1sDk3f+Y3jxMCqU=";
    }
    {
      path = "catppuccin/assets/mocha/equalizer-animated-yellow.gif";
      hash = "sha256-5ufc+ZdQfnS2ks7LPPU5v9BC37V+kQG2aXjDW7jfsB4=";
    }

    {
      path = "catppuccin/src/_main.scss";
      hash = "sha256-bsab1uOGzRmqyEEL9rr2BbnPg10klnYm3xOGK/Tg7CA=";
    }
    {
      path = "catppuccin/src/_navbar.scss";
      hash = "sha256-6OCssPkF0sflsEzm8l86LIU6TVzYQQuGz3rY298w5Ks=";
    }
    {
      path = "catppuccin/src/_now_playing.scss";
      hash = "sha256-Rx0p4MjSxmJm4Yj0PMN0Bv61cnxxfRDRiyaOuBptLR4=";
    }
    {
      path = "catppuccin/src/_right_sidebar.scss";
      hash = "sha256-F8tVXWDHL6l9Vj0XXejUjpCdPcW14381MEZJKGIk/pU=";
    }
    {
      path = "catppuccin/src/_top_bar.scss";
      hash = "sha256-PBXqWWGQVrRukkuMblnk7T4UxUcvem952IsRt0WCsPw=";
    }
    {
      path = "catppuccin/app.scss";
      hash = "sha256-Egq7VmkTwYOcYUK9pHUPORDb+PS3mM+eIzeT9MDLwg8=";
    }
    {
      path = "catppuccin/color.ini";
      hash = "sha256-9cK2pG6bRjAg+LNqIVF85q3p6JIwhQ8klEB25YZXbgc=";
    }
    {
      path = "catppuccin/theme.js";
      hash = "sha256-ysUcwSNrN7DRAK5BySeapvvysAqjMgZ4VNcu83vqFRw=";
    }
    {
      path = "catppuccin/user.css";
      hash = "sha256-m0appHL67SlX60Lfk9uAMbtbm5Tohq7CuZzgDXrLa8Y=";
    }
  ];

  themeFileAttrs = builtins.listToAttrs (
    map (f: {
      name = "${theme_dir}/${f.path}";
      value = {
        source = pkgs.fetchurl {
          url = "${theme_url}/${f.path}";
          hash = f.hash;
        };
      };
    }) themeFilesList
  );
in
{
  home = {
    packages = with pkgs; [
      unstable.spotify
      unstable.spicetify-cli
    ];

    activation = {
      spicetifyApply = lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" ] ''
        echo "Applying Spicetify theme..." >&2
        ${pkgs.unstable.spicetify-cli}/bin/spicetify backup apply >&2
      '';
    };

    file = themeFileAttrs // {
      "${config.xdg.configHome}/spicetify/config-xpui.ini" = {
        text = ''
          [Setting]
          color_scheme           = mocha
          inject_theme_js        = 1
          check_spicetify_update = 1
          spotify_path           = ${pkgs.unstable.spotify}/Applications/Spotify.app/Contents/Resources
          inject_css             = 1
          replace_colors         = 1
          overwrite_assets       = 1
          spotify_launch_flags   = 
          always_enable_devtools = 0
          prefs_path             = /Users/jan.pucilowski/Library/Application Support/Spotify/prefs
          current_theme          = catppuccin

          [Preprocesses]
          expose_apis        = 1
          disable_sentry     = 1
          disable_ui_logging = 1
          remove_rtl_rule    = 1

          [AdditionalOptions]
          extensions            = 
          custom_apps           = 
          sidebar_config        = 1
          home_config           = 1
          experimental_features = 1

          [Patch]

          ; DO NOT CHANGE!
          [Backup]
          version = 1.2.74.477.g3be53afe
          with    = 2.42.0
        '';
        force = true;
      };
    };
  };
}
