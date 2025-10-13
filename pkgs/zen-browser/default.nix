{
  stdenv,
  pkgs,
  fetchurl,
  lib,
}: let
  version = "1.14.4b";
  sha256 = "3afbb35ae1eef93cf92496c67fe3f745994995e2081e72ef32117edbc62185f0";
in
  stdenv.mkDerivation {
    pname = "Zen";
    inherit version;
    buildInputs = [pkgs.undmg];
    sourceRoot = ".";
    phases = [
      "unpackPhase"
      "installPhase"
    ];

    installPhase = ''
      mkdir -p "$out/Applications"
      cp -r Zen.app "$out/Applications/Zen.app"
    '';

    src = fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.macos-universal.dmg";
      inherit sha256;
    };

    meta = with lib; {
      description = "Zen Browser";
      homepage = "https://zen-browser.app/";
      platforms = ["aarch64-darwin"];
    };
  }
