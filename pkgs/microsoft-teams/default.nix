{
  lib,
  stdenv,
  fetchurl,
  xar,
  cpio,
  pbzx,
}:
stdenv.mkDerivation rec {
  pname = "microsoft-teams";
  version = "25016.1904.3401.2239";

  src = fetchurl {
    url = "https://statics.teams.cdn.office.net/production-osx/${version}/MicrosoftTeams.pkg";
    sha256 = "63a283bf5a022a221478df5630fb3e2b160bc20f3a7c13f09f350241cbf2b16e";
  };

  nativeBuidldInputs = [
    xar
    cpio
    pbzx
  ];

  unpackPhase = ''
    /usr/bin/xar -xf $src
    ${pbzx}/bin/pbzx -n MicrosoftTeams_app.pkg/Payload | /usr/bin/cpio -i
  '';

  sourceRoot = "Microsoft Teams.app";
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R . $out/Applications/Microsoft\ Teams.app/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Microsoft Teams - Meet, chat, call, and collaborate in just one place";
    homepage = "https://www.microsoft.com/en/microsoft-teams/group-chat-software/";
    platforms = ["aarch64-darwin"];
    license = licenses.unfree;
    maintainers = with maintainers; ["janpuc"];
  };
}
