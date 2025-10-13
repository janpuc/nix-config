{
  stdenv,
  pkgs,
  fetchurl,
  _7zz,
  lib,
}: let
  version = "2.6.0";
  sha256 = "87FjkAYD9vbjDUFydXdMj37z2gJ7dUtsaQW/w/KGGJM=";
in
  stdenv.mkDerivation {
    pname = "Proton Drive";
    inherit version;

    src = fetchurl {
      url = "https://proton.me/download/drive/macos/${version}/ProtonDrive-${version}.dmg";
      inherit sha256;
    };

    nativeBuildInputs = [_7zz];

    installPhase = ''
      mkdir -p $out/Applications/Proton\ Drive.app
      cp -r . $out/Applications/Proton\ Drive.app/
    '';

    meta = with lib; {
      description = "Proton Drive";
      homepage = "https://proton.me/drive";
      platforms = ["aarch64-darwin"];
    };
  }
