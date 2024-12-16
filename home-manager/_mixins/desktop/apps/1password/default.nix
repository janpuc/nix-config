{
  lib,
  pkgs,
  username,
  ...
}: let
  _1password-gui-pkg = pkgs._1password-gui.overrideAttrs (old: {
    meta =
      old.meta
      // {
        broken = false;
      };
  });
  move1PasswordScript = pkgs.writeShellScriptBin "move-1password" ''
    SOURCE="${_1password-gui-pkg}/Applications/1Password.app"
    HOME_MANAGER_DEST="$HOME/Applications/Home Manager Applications/1Password.app"
    SYSTEM_DEST="/Applications/1Password.app"
    STAMP_FILE="$HOME/.1password-move-stamp"

    CURRENT_VERSION=$(${pkgs.nix}/bin/nix-instantiate --eval -E '(import <nixpkgs> {})._1password.version' | tr -d '"')

    if [ -d "$HOME_MANAGER_DEST" ]; then
      rm -rf "$HOME_MANAGER_DEST"
    fi

    if [ ! -f "$STAMP_FILE" ] || [ "$(cat "$STAMP_FILE")" != "$CURRENT_VERSION" ]; then
      /usr/bin/osascript <<EOD
        do shell script "
          if [ ! -d '$SOURCE' ]; then
            echo 'Source application not found'
            exit 1
          fi

          rm -rf '$SYSTEM_DEST'

          ditto '$SOURCE' '$SYSTEM_DEST'

          chmod -R 755 '$SYSTEM_DEST'
          chown -R root:wheel '$SYSTEM_DEST'

          if [ ! -d '$SYSTEM_DEST' ]; then
            echo 'Failed to copy application'
            exit 1
          fi
        " with administrator privileges
EOD
      if [ $? -eq 0 ]; then
        echo "$CURRENT_VERSION" > "$STAMP_FILE"
        echo "1Password successfully copied to /Applications"
      else
        echo "Failed to copy 1Password"
        exit 1
      fi
    fi
  '';
in {
  home = {
    # activation = {
    #   copy1PassToApplications = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #     appsDir="/Users/${username}/Applications/Home Manager Apps"
    #     if [ -d "$appsDir" ]; then
    #       rm -rf "$appsDir/1Password.app"
    #     fi

    #     app="/Applications/1Password.app"
    #     if [ -L "$app" ] || [ -f "$app"  ]; then
    #       rm "$app"
    #     fi

    #     rsyncFlags=(
    #       --archive
    #       --checksum
    #       --chmod=-w
    #       --copy-unsafe-links
    #       --delete
    #       --no-group
    #       --no-owner
    #     )
    #     ${lib.getBin pkgs.rsync}/bin/rsync "''${rsyncFlags[@]}" \
    #       ${lib.getBin _1password-gui-pkg}/Applications/1Password.app/ /Applications/1Password.app
    #   '';
    # };
    activation = {
      move1Password = lib.hm.dag.entryAfter ["writeBoundary"] ''
        ${move1PasswordScript}/bin/move-1password
      '';
    };
    packages = [
      _1password-gui-pkg
      move1PasswordScript
    ];
  };
}
