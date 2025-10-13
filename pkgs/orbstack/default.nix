{
  stdenv,
  fetchurl,
  _7zz,
  lib,
}: let
  version = "1.10.0_19021";
  sha256 = "e65f9df1810f74e6e0229cc47b999877fabeb5290011cfb90914177508b114b3";
in
  stdenv.mkDerivation {
    pname = "orbstack";
    inherit version;

    src = fetchurl {
      url = "https://cdn-updates.orbstack.dev/arm64/OrbStack_v${version}_arm64.dmg";
      inherit sha256;
    };

    dontUnpack = true;

    nativeBuildInputs = [_7zz];

    installPhase = ''
      mkdir extraction

      ${_7zz}/bin/7zz x $src -oextraction -snld || echo "Warning: extraction encountered errors"

      mkdir -p $out/Applications
      cp -r extraction/OrbStack.app $out/Applications/

      mkdir -p $out/bin
      ln -s $out/Applications/OrbStack.app/Contents/MacOS/bin/orb $out/bin/orb
      ln -s $out/Applications/OrbStack.app/Contents/MacOS/bin/orbctl $out/bin/orbctl

      ln -s $out/Applications/OrbStack.app/Contents/MacOS/xbin/docker $out/bin/docker
      ln -s $out/Applications/OrbStack.app/Contents/MacOS/xbin/docker-buildx $out/bin/docker-buildx
      ln -s $out/Applications/OrbStack.app/Contents/MacOS/xbin/docker-compose $out/bin/docker-compose
      ln -s $out/Applications/OrbStack.app/Contents/MacOS/xbin/docker-credential-osxkeychain $out/bin/docker-credential-osxkeychain

      mkdir -p $out/share/completions
      mkdir -p $out/share/completions/zsh

      cp $out/Applications/OrbStack.app/Contents/Resources/completions/docker.bash $out/share/completions/docker.bash
      cp $out/Applications/OrbStack.app/Contents/Resources/completions/docker.fish $out/share/completions/docker.fish
      cp $out/Applications/OrbStack.app/Contents/Resources/completions/zsh/_docker $out/share/completions/zsh/_docker
    '';

    dontFixup = true;

    meta = with lib; {
      description = "Replacement for Docker Desktop";
      homepage = "https://orbstack.dev/";
      license = licenses.unfree;
      platforms = ["aarch64-darwin"];
    };
  }
