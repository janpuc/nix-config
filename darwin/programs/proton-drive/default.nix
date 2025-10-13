{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.proton-drive;
in {
  options = {
    programs.proton-drive = {
      enable = lib.mkEnableOption "Proton Drive";

      package = lib.mkPackageOption pkgs "Proton Drive" {
        default = ["proton-drive"];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    system.activationScripts.applications.text = lib.mkAfter ''
      install -o root -g wheel -m0555 -d "/Applications/Proton Drive.app"

      rsyncFlags=(
        # mtime is standardized in the nix store, which would leave only file size to distinguish files.
        # Thus we need checksums, despite the speed penalty.
        --checksum
        # Converts all symlinks pointing outside of the copied tree (thus unsafe) into real files and directories.
        # This neatly converts all the symlinks pointing to application bundles in the nix store into
        # real directories, without breaking any relative symlinks inside of application bundles.
        # This is good enough, because the make-symlinks-relative.sh setup hook converts all $out internal
        # symlinks to relative ones.
        --copy-unsafe-links
        --archive
        --delete
        --chmod=-w
        --no-group
        --no-owner
      )

      ${lib.getExe pkgs.rsync} "''${rsyncFlags[@]}" \
        ${cfg.package}/Applications/Proton\ Drive.app/ /Applications/Proton\ Drive.app
    '';
  };
}
