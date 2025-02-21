{
  stdenv,
  fetchurl,
  _7zz,
  lib,
}: let
  version = "01.10.02.72";
  sha256 = "151jz2yn7sbanb40kazji6jx3npvjf8b3lmx0ai9czj2a2ayhl4h";
in
  stdenv.mkDerivation {
    pname = "BambuStudio";
    inherit version;

    src = fetchurl {
      url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_mac-v${version}-20250217113614.dmg";
      inherit sha256;
    };

    dontUnpack = true;

    nativeBuildInputs = [_7zz];

    installPhase = ''
      mkdir extraction

      ${_7zz}/bin/7zz x $src -oextraction || echo "Warning: extraction encountered errors"

      mkdir -p $out/Applications
      cp -r extraction/Bambu\ Studio/BambuStudio.app $out/Applications/
    '';

    meta = with lib; {
      description = "BambuStudio Beta Release for macOS on ARM64";
      homepage = "https://github.com/bambulab/BambuStudio";
      license = licenses.unfree;
      platforms = ["aarch64-darwin"];
      maintainers = ["janpuc"];
    };
  }
