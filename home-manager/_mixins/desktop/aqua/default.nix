{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
in
lib.mkIf isDarwin {
  targets.darwin = {
    currentHostDefaults = { };
  };
}
