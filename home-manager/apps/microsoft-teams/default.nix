{
  lib,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      (brewCasks.microsoft-teams.overrideAttrs (oldAttrs: {
        nativeBuidldInputs = [
          xar
          cpio
          pbzx
        ];

        unpackPhase = ''
          /usr/bin/xar -xf $src
          ${pkgs.pbzx}/bin/pbzx -n MicrosoftTeams_app.pkg/Payload | /usr/bin/cpio -i
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
      }))
    ];
  };
}
