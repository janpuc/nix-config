{
  stdenv,
  fetchurl,
  unzip,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "beeper";
  version = "4.0.445";
  src = fetchurl {
    url = "https://api.beeper.com/desktop/download/macos/arm64/stable/com.automattic.beeper.desktop";
    sha256 = "0s2v1srv6lkwxfzgvym4pl3vb5b0afmrz9b6925xlkjd502l993h";
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
