{
  stdenv,
  fetchurl,
  _7zz,
  lib,
}: let
  version = "02.01.01.52";
  buildNumber = "20250616155614";
  sha256 = "c60c57fb743de63ce3b8bd7ab2a78642d9ae61dc319db6e442c077093711e4b4";
in
  stdenv.mkDerivation {
    pname = "BambuStudio";
    inherit version;

    src = fetchurl {
      url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_mac-v${version}-${buildNumber}.dmg";
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
      description = "BambuStudio Public Release for macOS on ARM64";
      homepage = "https://github.com/bambulab/BambuStudio";
      license = licenses.unfree;
      platforms = ["aarch64-darwin"];
      maintainers = ["janpuc"];
    };
  }
