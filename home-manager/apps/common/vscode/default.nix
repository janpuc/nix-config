{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # INFO: Switch to plain VSCode before I figure out how to add cpp, copilot etc. to VSCodium
    package = pkgs.vscode;

    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        # nix
        bbenoist.nix # nix LSP
        kamadorueda.alejandra # nix linter
        # rust
        rust-lang.rust-analyzer
        # cpp
        # ms-vscode.cpptools
        # js
        dbaeumer.vscode-eslint
        # yaml
        redhat.vscode-yaml # yaml LSP
        # terraform
        hashicorp.terraform
        # opentofu.vscode-opentofu
        # misc
        skellock.just # justfile lint
      ];

      keybindings = [
        # Needed for MacOS window management shortcuts
        {
          key = "ctrl+shift+alt+cmd+right";
          command = "quickInput.acceptInBackground";
          when = "cursorAtEndOfQuickInputBox && inQuickInput && quickInputType == 'quickPick' || inQuickInput && !inputFocus && quickInputType == 'quickPick'";
        }
        {
          key = "ctrl+shift+alt+cmd+down";
          command = "quickInput.nextSeparator";
          when = "inQuickInput && quickInputType == 'quickPick' || inQuickInput && quickInputType == 'quickTree'";
        }
        {
          key = "ctrl+shift+alt+cmd+up";
          command = "quickInput.previousSeparator";
          when = "inQuickInput && quickInputType == 'quickPick' || inQuickInput && quickInputType == 'quickTree'";
        }
      ];

      userSettings = {
        # global
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', monospace";
        # nix
        "alejandra.program" = "alejandra";
        "[nix]" = {
          "editor.defaultFormatter" = "kamadorueda.alejandra";
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;
        };
        # misc
        "redhat.telemetry.enabled" = false;
      };
    };
  };
}
