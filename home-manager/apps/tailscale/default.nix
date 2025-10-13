{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      tailscale
    ];
  };
}
# {
#   lib,
#   pkgs,
#   ...
# }: {
#   home = {
#     packages = with pkgs; [
#       (brewCasks.tailscale-app.overrideAttrs (oldAttrs: {
#         nativeBuidldInputs = [
#           xar
#           cpio
#           pbzx
#         ];
#         unpackPhase = ''
#           /usr/bin/xar -xf $src
#           ${pkgs.pbzx}/bin/pbzx -n Distribution.pkg/Payload | /usr/bin/cpio -i
#         '';
#         sourceRoot = "Distribution.pkg";
#         dontPatch = true;
#         dontConfigure = true;
#         dontBuild = true;
#         installPhase = ''
#           runHook preInstall
#           mkdir -p $out/Applications
#           ls -la
#           cp -R . $out/Applications/Tailscale.app/
#           runHook postInstall
#         '';
#       }))
#     ];
#   };
# }

