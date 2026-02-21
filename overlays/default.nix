# This file defines overlays
{ inputs, ... }:
{
  additions = final: _prev: import ../pkgs final.pkgs;
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
  brew-nix = final: _prev: {
    brew = import inputs.brew-nix.overlays.default {
      inherit (final) system;
    };
  };

  modifications = _final: prev: {
    # Fix inetutils build failure on Darwin with clang 21
    # gnulib's error() macro passes dgettext() results as format strings,
    # triggering -Werror,-Wformat-security in openat-die.c
    # See: https://github.com/NixOS/nixpkgs/issues/488689
    inetutils = prev.inetutils.overrideAttrs (
      old:
      prev.lib.optionalAttrs prev.stdenv.isDarwin {
        env = (old.env or { }) // {
          NIX_CFLAGS_COMPILE = toString [
            (old.env.NIX_CFLAGS_COMPILE or "")
            "-Wno-format-security"
          ];
        };
      }
    );
  };
}
