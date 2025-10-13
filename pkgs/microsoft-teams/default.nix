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
  version = "25163.3001.3726.6503";

  src = fetchurl {
    url = "https://statics.teams.cdn.office.net/production-osx/${version}/MicrosoftTeams.pkg";
    sha256 = "fHtV6Ibn+5Tc4a5ENk3rcB61pvWNssTIJ3VKP9PypTg=";
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
