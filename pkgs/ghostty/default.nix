{
  stdenv,
  fetchurl,
  _7zz,
  lib,
}: let
  version = "1.1.3";
  sha256 = "64e514188f549598f166d6dcb6f8df29f333e954e28172a2901ea988a14f2647";
in
  stdenv.mkDerivation {
    pname = "ghostty";
    inherit version;

    src = fetchurl {
      url = "https://release.files.ghostty.org/${version}/Ghostty.dmg";
      inherit sha256;
    };

    nativeBuildInputs = [_7zz];

    installPhase = ''
      mkdir -p $out/Applications/Ghostty.app
      cp -r . $out/Applications/Ghostty.app/

      mkdir -p $out/bin
      ln -s $out/Applications/Ghostty.app/Contents/MacOS/ghostty $out/bin/ghostty

      mkdir -p $out/share/bash-completion/completions
      mkdir -p $out/share/fish/vendor_completions.d
      mkdir -p $out/share/zsh/site-functions
      mkdir -p $out/share/man/man1
      mkdir -p $out/share/man/man5

      cp $out/Applications/Ghostty.app/Contents/Resources/bash-completion/completions/ghostty.bash $out/share/bash-completion/completions/ghostty.bash
      cp $out/Applications/Ghostty.app/Contents/Resources/fish/vendor_completions.d/ghostty.fish $out/share/fish/vendor_completions.d/ghostty.fish
      cp $out/Applications/Ghostty.app/Contents/Resources/zsh/site-functions/_ghostty $out/share/zsh/site-functions/_ghostty
      cp $out/Applications/Ghostty.app/Contents/Resources/man/man1/ghostty.1 $out/share/man/man1/ghostty.1
      cp $out/Applications/Ghostty.app/Contents/Resources/man/man5/ghostty.5 $out/share/man/man5/ghostty.5
    '';

    dontFixup = true;

    meta = with lib; {
      description = "Terminal emulator that uses platform-native UI and GPU acceleration";
      homepage = "https://ghostty.org/";
      license = licenses.unfree;
      platforms = ["aarch64-darwin"];
    };
  }
