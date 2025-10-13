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

  # AppleScript to move 1Password to /Applications
  move1PasswordAppleScript = pkgs.writeTextFile {
    name = "move-1password.applescript";
    text = ''
      on run argv
        set sourceApp to item 1 of argv
        set destApp to item 2 of argv
        do shell script "
          if [ ! -d " & quoted form of sourceApp & " ]; then
            echo 'Source application not found'
            exit 1
          fi

          rm -rf " & quoted form of destApp & "
          /usr/bin/ditto " & quoted form of sourceApp & " " & quoted form of destApp & "
          chmod -R 755 " & quoted form of destApp & "
          chown -R root:wheel " & quoted form of destApp & "

          if [ ! -d " & quoted form of destApp & " ]; then
            echo 'Failed to copy application'
            exit 1
          fi
        " with administrator privileges
      end run
    '';
  };

  # Shell script that calls the AppleScript
  move1PasswordScript = pkgs.writeShellScriptBin "move-1password" ''
    #!/bin/bash

    SOURCE="${_1password-gui-pkg}/Applications/1Password.app"
    DEST="/Applications/1Password.app"
    STAMP_FILE="$HOME/Library/Application Support/1Password/.1password-move-stamp"

    # Ensure the directory exists
    mkdir -p "$(dirname "$STAMP_FILE")"

    CURRENT_VERSION=$(${pkgs.nix}/bin/nix-instantiate --eval -E '(import <nixpkgs> {})._1password-gui.version' | tr -d '"')

    # Remove Home Manager symlink if it exists
    HOME_MANAGER_DEST="$HOME/Applications/Home Manager Applications/1Password.app"
    if [ -d "$HOME_MANAGER_DEST" ]; then
      rm -rf "$HOME_MANAGER_DEST"
    fi

    # Check if we need to update
    if [ ! -f "$STAMP_FILE" ] || [ "$(cat "$STAMP_FILE")" != "$CURRENT_VERSION" ]; then
      /usr/bin/osascript ${move1PasswordAppleScript} "$SOURCE" "$DEST"

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
