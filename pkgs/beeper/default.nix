{
  stdenv,
  fetchurl,
  unzip,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "beeper";
  version = "4.0.821";
  src = fetchurl {
    # url = "https://api.beeper.com/desktop/download/macos/arm64/stable/com.automattic.beeper.desktop";
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-${version}-arm64-mac.zip";
    sha256 = "OeQVQ7QnTni3HPcIaDPH6JJaIaTeS8S85HCnXo9i2fk=";
  };

  nativeBuildInputs = [unzip];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -r "Beeper Desktop.app" $out/Applications
  '';

  meta = with lib; {
    description = "All your chats in one app";
    homepage = "https://www.beeper.com";
    license = licenses.unfree;
    platforms = ["aarch64-darwin"];
    maintainers = ["janpuc"];
  };
}
